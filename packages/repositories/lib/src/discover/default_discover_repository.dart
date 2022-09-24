import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cache/cache.dart';

import 'package:controllers/controllers.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

class DiscoverRepositoryImplementation implements DiscoverRepository {
  DiscoverRepositoryImplementation({
    required DiscoverController discoverController,
    required AsymmetricEncryptionService asymmetricEncryptionService,
    required SymmetricEncryptionService symmetricEncryptionService,
    required CacheClient cacheClient,
    required NotificationService notificationService,
    required String directoryToStoreFiles,
  })  : _discoverController = discoverController,
        _asymmetricEncryptionService = asymmetricEncryptionService,
        _symmetricEncryptionService = symmetricEncryptionService,
        _cacheClient = cacheClient,
        _notificationService = notificationService,
        _directoryToStoreFiles = directoryToStoreFiles;

  // Private fields
  final DiscoverController _discoverController;
  final AsymmetricEncryptionService _asymmetricEncryptionService;
  final SymmetricEncryptionService _symmetricEncryptionService;
  final CacheClient _cacheClient;
  final NotificationService _notificationService;
  final String _directoryToStoreFiles;

  final StreamController<Partner> _partnerController =
      StreamController<Partner>.broadcast();

  final StreamController<AddLikeMessage> _receivedLikeController =
      StreamController<AddLikeMessage>.broadcast();

  final StreamController<RemoveLikeMessage> _receivedRemoveLikeController =
      StreamController<RemoveLikeMessage>.broadcast();

  final StreamController<AddLikeMessage> _sendedLikeController =
      StreamController<AddLikeMessage>.broadcast();

  final StreamController<RemoveLikeMessage> _sendedRemovedLikeController =
      StreamController<RemoveLikeMessage>.broadcast();

  @override
  Stream<Partner> get possiblePartners => _partnerController.stream;

  @override
  Stream<AddLikeMessage> get receivedLike => _receivedLikeController.stream;

  @override
  Stream<RemoveLikeMessage> get receivedRemoveLike =>
      _receivedRemoveLikeController.stream;

  @override
  Stream<AddLikeMessage> get sendedLike => _sendedLikeController.stream;

  @override
  Stream<RemoveLikeMessage> get sendedRemoveLike =>
      _sendedRemovedLikeController.stream;

  @override
  Future<void> fetch({
    int numberOfPartners = 10,
    List<String> alreadyFetchedUsers = const [],
    Map<String, List<String>> userToKeys = const {},
    dynamic options,
  }) async {
    const fetchEachRound = 2;
    final fetchRound = (numberOfPartners / fetchEachRound).ceil();
    final localAlreadyFetchedUsers = [...alreadyFetchedUsers];
    for (var i = 0; i < fetchRound; i++) {
      final partnersDTO = await _discoverController.fetchPartners(
        numberOfPartner: fetchEachRound,
        alreadyFetchedUsers: localAlreadyFetchedUsers,
        options: options,
      );
      for (final partnerDTO in partnersDTO) {
        final keys = userToKeys[partnerDTO.username];
        final partner = partnerDTO.toPartner(_symmetricEncryptionService, keys);
        _partnerController.add(partner);
        _cacheClient.write<Partner>(
          key: '${partner.username} $keys',
          value: partner,
        );
        localAlreadyFetchedUsers.add(partnerDTO.username);
      }
    }
  }

  @override
  Future<Partner> fetchPartner({
    required String username,
    List<String>? keys,
  }) async {
    final partnerFromCache =
        getPartnerFromCache(username: username, keys: keys);
    if (partnerFromCache != null) return partnerFromCache;
    final partnerDTO = await _discoverController.fetchPartner(
      username: username,
    );
    final partner = partnerDTO.toPartner(_symmetricEncryptionService, keys);
    _cacheClient.write<Partner>(key: '$username $keys', value: partner);
    return partner;
  }

  @override
  Future<void> putLike({
    required Partner partner,
    required String fromUsername,
  }) async {
    final symmetricKeys = _symmetricEncryptionService.loadedKeys;
    final partnerUsername = partner.username;
    final addLikeMessage = AddLikeMessage(
      username: fromUsername,
      keys: symmetricKeys,
    );
    final sealedLikeMessage = await _createSealedMessage(
      addLikeMessage,
      LikeMessageType.addLike,
      partner,
    );
    await _discoverController.sendSealedLikeMessage(
      to: partnerUsername,
      sealedLikeMessage: sealedLikeMessage,
    );
    _sendedLikeController
        .add(AddLikeMessage(username: partner.username, keys: symmetricKeys));
  }

  @override
  Future<void> removeLike({
    required Partner partner,
    required String fromUsername,
  }) async {
    final partnerUsername = partner.username;
    final removeLikeMessage = RemoveLikeMessage(
      username: partnerUsername,
    );
    final sealedLikeMessage = await _createSealedMessage(
      removeLikeMessage,
      LikeMessageType.removeLike,
      partner,
    );
    await _discoverController.sendSealedLikeMessage(
      to: partnerUsername,
      sealedLikeMessage: sealedLikeMessage,
    );
    _sendedRemovedLikeController.add(removeLikeMessage);
  }

  @override
  Future<File> fetchPublicImage({
    required String username,
    required String id,
  }) async {
    final picFromCache = getPictureFromCache(picId: id, private: false);
    if (picFromCache != null) return picFromCache;
    final image = await _discoverController.fetchPartnerPublicPicture(
      username: username,
      id: id,
    );
    _savePictureToCache(picId: id, private: false, picture: image);
    return image;
  }

  @override
  Future<File> fetchPrivateImage({
    required String username,
    required String id,
    required String base64Key,
  }) async {
    final picFromCache = getPictureFromCache(picId: id, private: true);
    if (picFromCache != null) return picFromCache;
    final encryptedPic =
        await _discoverController.fetchPartnerEncryptedPrivatePicture(
      username: username,
      id: id,
    );
    final decryptedPic = await _symmetricEncryptionService.decryptFile(
      inputFile: encryptedPic,
      username: username,
      newFilePath: '$_directoryToStoreFiles/private/$id',
      base64Key: base64Key,
    );
    _savePictureToCache(picId: id, private: true, picture: decryptedPic);
    return decryptedPic;
  }

  @override
  Partner? getPartnerFromCache({required String username, List<String>? keys}) {
    final cachedPartner = _cacheClient.read<Partner>(key: '$username $keys');
    return cachedPartner;
  }

  @override
  File? getPictureFromCache({required String picId, required bool private}) {
    final cachedPicPath = _cacheClient.read<String>(key: '$picId$private');
    return cachedPicPath != null ? File(cachedPicPath) : null;
  }

  @override
  Map<String, File> getPicturesFromCache({required Partner partner}) {
    final pics = <String, File>{};
    for (final picId in partner.publicInfo.pictures) {
      final pic = getPictureFromCache(picId: picId, private: false);
      if (pic != null) pics.putIfAbsent(picId, () => pic);
    }
    if (partner.hasPrivateInfo) {
      for (final privatePic in partner.privateInfo!.pictures) {
        final picId = privatePic.picId;
        final pic = getPictureFromCache(picId: picId, private: false);
        if (pic != null) pics.putIfAbsent(picId, () => pic);
      }
    }
    return pics;
  }

  void _savePictureToCache({
    required String picId,
    required bool private,
    required File picture,
  }) {
    _cacheClient.write<String>(key: '$picId$private', value: picture.path);
  }

  Future<String> _createSealedMessage(
    LikeMessage likeMessage,
    LikeMessageType addLike,
    Partner partner,
  ) async {
    final signedPartnerUsername =
        await _asymmetricEncryptionService.sign(partner.username);
    final packedMessage = PackedLikeMessage(
      type: addLike.toString(),
      likeMessage: likeMessage.toJson(),
      signedPartnerUsername: signedPartnerUsername,
    );
    final sealedMessage = await _asymmetricEncryptionService.encrypt(
      json.encode(packedMessage),
      partner.jsonPublicKey,
    );
    return base64.encode(sealedMessage.toList());
  }

  Future<LikeMessage> _extractSealedMessage({
    required String sealedMessage,
    required String localUsername,
  }) async {
    final decodedSealedMessage = base64.decode(sealedMessage);
    final decryptedPackedMessage =
        await _asymmetricEncryptionService.decrypt(decodedSealedMessage);
    final packedMessage = PackedLikeMessage.fromJson(
      json.decode(decryptedPackedMessage) as Map<String, dynamic>,
    );
    final likeMessage = LikeMessage.fromJson(packedMessage.likeMessage);
    final publicKey = await _discoverController.fetchPublicKey(
      username: likeMessage.username,
    );
    if (!_asymmetricEncryptionService.verifySignature(
      publicKey,
      localUsername,
      packedMessage.signedPartnerUsername,
    )) {
      throw SignatureVerificationException();
    }
    if (packedMessage.type == LikeMessageType.addLike.toString()) {
      return AddLikeMessage.fromJson(packedMessage.likeMessage);
    } else if (packedMessage.type == LikeMessageType.removeLike.toString()) {
      return RemoveLikeMessage.fromJson(packedMessage.likeMessage);
    } else {
      throw SignatureVerificationException();
    }
  }

  @override
  void subscribeToLikeMessages({required String username}) {
    _notificationService.notifications.listen((notificationDTO) async {
      final notification = notificationDTO.toNotification();
      if (!notification.isLikeMessage()) return;
      final notificationContent = notification.content as Map<String, dynamic>;
      try {
        final extractedLikeMessage = await _extractSealedMessage(
          sealedMessage: notificationContent['content'] as String,
          localUsername: username,
        );
        if (extractedLikeMessage is AddLikeMessage) {
          _receivedLikeController.add(extractedLikeMessage);
        } else if (extractedLikeMessage is RemoveLikeMessage) {
          _receivedRemoveLikeController.add(extractedLikeMessage);
        }
      } catch (_) {
        // SealedMessage is invalid
      }
    });
  }
}

enum LikeMessageType { addLike, removeLike }

class SignatureVerificationException implements Exception {}

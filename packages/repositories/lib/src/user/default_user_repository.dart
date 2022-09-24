import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:controllers/controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:path/path.dart' as path;
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

class DefaultUserRepository extends UserRepository {
  DefaultUserRepository({
    required AuthenticationController authenticationController,
    required UserController userController,
    required AsymmetricEncryptionService asymmetricEncryptionService,
    required SymmetricEncryptionService symmetricEncryptionService,
    required NotificationService notificationService,
    required String directoryToStoreFiles,
  })  : _authenticationController = authenticationController,
        _userController = userController,
        _asymmetricEncryptionService = asymmetricEncryptionService,
        _symmetricEncryptionService = symmetricEncryptionService,
        _notificationService = notificationService,
        _directoryToStoreFiles = directoryToStoreFiles;

  // Private fields
  final AuthenticationController _authenticationController;
  final UserController _userController;
  final AsymmetricEncryptionService _asymmetricEncryptionService;
  final SymmetricEncryptionService _symmetricEncryptionService;
  final NotificationService _notificationService;
  final String _directoryToStoreFiles;

  final StreamController<LocalUser> _userStreamController =
      StreamController<LocalUser>.broadcast()..add(LocalUser.empty);
  LocalUser _currentUser = LocalUser.empty;

  // Properties
  @override
  Stream<LocalUser> get user async* {
    yield _currentUser;
    yield* _userStreamController.stream;
  }

  @override
  LocalUser get currentUser => _currentUser;

  // Public Methods
  @override
  Future<void> signUp({required LocalSignupUser signupUser}) async {
    final username = signupUser.username;
    final password = signupUser.password;
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      throw Error();
    }
    await _asymmetricEncryptionService.createKeyPair(
      username,
      password,
    );
    final jsonPublicKey = _asymmetricEncryptionService.jsonPublicKey;
    await _authenticationController.signUp(
      username: username,
      publicKey: jsonPublicKey,
    );
    _symmetricEncryptionService.generateAndStoreNewKey();
    final symmetricKeys = json.encode(_symmetricEncryptionService.loadedKeys);
    final encryptedSymmetricKeys =
        await _asymmetricEncryptionService.encryptWithLoadedKey(symmetricKeys);
    final userDTO = await signupUser.toUserDTO(
      asymmetricEncryptionService: _asymmetricEncryptionService,
      symmetricEncryptionService: _symmetricEncryptionService,
    );
    await _userController.pushUser(userDTO);
    final publicPictures =
        await _uploadAndRenamePublicPictures(signupUser.pictures ?? []);
    final privatePictures = await _encryptUploadAndRenamePrivatePictures(
      signupUser.privatePictures ?? [],
      username,
      _symmetricEncryptionService,
    );
    await _userController.pushSymmetricEncryptedKeys(
      base64.encode(encryptedSymmetricKeys),
    );
    final newSignupUser = signupUser.copyWith(
      pictures: publicPictures,
      privatePictures: privatePictures,
    );
    final localUser = newSignupUser.toLocalUser();
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  Future<List<File>> _uploadAndRenamePublicPictures(List<File> pictures) async {
    return Future.wait<File>(
      pictures.map<Future<File>>((picture) async {
        final picId = await _userController.pushPublicPic(picture);
        return picture.rename('${path.dirname(picture.path)}/$picId');
      }).toList(),
    );
  }

  Future<List<File>> _encryptUploadAndRenamePrivatePictures(
    List<File> pictures,
    String username,
    SymmetricEncryptionService encryptionService,
  ) async {
    final rng = Random();
    return Future.wait<File>(
      pictures.map<Future<File>>((picture) async {
        final encryptedPic = await encryptionService.encryptFile(
          inputFile: picture,
          username: username,
          newFilePath: '$_directoryToStoreFiles${rng.nextInt(100)}.enc',
        );
        final picId = await _userController.pushEncryptedPrivatePic(
          encryptedPic,
          encryptionService.lastKeyIndex,
        );
        return picture.rename('${path.dirname(picture.path)}/$picId');
      }).toList(),
    );
  }

  @override
  Future<void> logInWithUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    await _asymmetricEncryptionService.createKeyPair(username, password);
    final tokenDTO = await _authenticationController.getLoginChallenge(
      username: username,
    );
    final dataToSign = tokenDTO.challenge.dataToSign;
    final signedChallenge = await _asymmetricEncryptionService.sign(dataToSign);
    await _authenticationController.logIn(
      username: username,
      token: tokenDTO,
      signedChallenge: signedChallenge,
    );
    final symmetricEncryptedKeys =
        base64.decode(await _userController.fetchSymmetricEncryptedKeys());
    final symmetricKeys = json.decode(
      await _asymmetricEncryptionService.decrypt(symmetricEncryptedKeys),
    ) as List<dynamic>;
    _symmetricEncryptionService.loadKey(symmetricKeys.cast<String>());
    final userDTO = await _userController.fetchUser();
    final publicPicIds = userDTO.publicInfo.pictures;
    final publicPics = await _userController.fetchPublicPics(
      publicPicIds,
      userDTO.username,
    );
    final privatePicDTOs = userDTO.privateInfo.pictures ?? [];
    final privatePics = await Future.wait(
      privatePicDTOs.map<Future<PrivatePic>>((privatePicDTO) async {
        final decryptedPic = await _fromPrivatePicDTOToDecryptFile(
          userDTO.username,
          privatePicDTO,
          _directoryToStoreFiles,
        );
        return PrivatePic(
          picId: decryptedPic.path,
          keyIndex: privatePicDTO.key,
        );
      }).toList(),
    );
    final publicPicPaths = publicPics.map((pp) => pp.path).toList();
    final localUser = userDTO.toLocalUser(
      encryptionService: _symmetricEncryptionService,
      privatePics: privatePics,
      publicPics: publicPicPaths,
    );
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  @override
  Future<void> logOut() async {
    await _authenticationController.logOut();
    _notificationService.kill();
    _currentUser = LocalUser.empty;
    _userStreamController.add(LocalUser.empty);
  }

  @override
  Future<bool> doesUserExist(String username) async =>
      _authenticationController.doesUserExist(username);

  Future<File> _fromPrivatePicDTOToDecryptFile(
    String username,
    PrivatePictureDTO privatePicDTO,
    String dirPath,
  ) async {
    final id = privatePicDTO.id;
    final encryptedPic =
        (await _userController.fetchEncryptedPrivatePics([id], username)).first;

    final decryptedPic = _symmetricEncryptionService.decryptFileWithLoadedKey(
      inputFile: encryptedPic,
      username: username,
      newFilePath: dirPath + id,
      keyIndex: privatePicDTO.key,
    );

    return decryptedPic;
  }

  @override
  Future<void> editStandardInfo(StandardInfo standardInfo) async {
    final publicTextInfo = {...standardInfo.textInfo}
      ..removeWhere((key, value) => value.private);
    final publicDateInfo = {...standardInfo.dateInfo}
      ..removeWhere((key, value) => value.private);
    final publicBoolInfo = {...standardInfo.boolInfo}
      ..removeWhere((key, value) => value.private);
    final publicInfo = currentUser.publicInfo.copyWith(
      textInfo: publicTextInfo.map((key, value) => MapEntry(key, value.data)),
      boolInfo: publicBoolInfo.map((key, value) => MapEntry(key, value.data)),
      dateInfo: publicDateInfo.map((key, value) => MapEntry(key, value.data)),
    );

    final privateTextInfo = {...standardInfo.textInfo}
      ..removeWhere((key, value) => !value.private);
    final privateDateInfo = {...standardInfo.dateInfo}
      ..removeWhere((key, value) => !value.private);
    final privateBoolInfo = {...standardInfo.boolInfo}
      ..removeWhere((key, value) => !value.private);
    final privateInfo = currentUser.privateInfo.copyWith(
      textInfo: privateTextInfo.map((key, value) => MapEntry(key, value.data)),
      boolInfo: privateBoolInfo.map((key, value) => MapEntry(key, value.data)),
      dateInfo: privateDateInfo.map((key, value) => MapEntry(key, value.data)),
    );
    final localUser = LocalUser(
      username: currentUser.username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
    _symmetricEncryptionService.generateAndStoreNewKey();
    final base64EncryptedKeys = await _getEncodedEncryptedKeys();
    final userDTO = UserDTO(
      username: localUser.username,
      publicInfo: localUser.publicInfo.toPublicInfoDTO,
      privateInfo: localUser.privateInfo.toPrivateInfoDTO(
        encryptionService: _symmetricEncryptionService,
        username: localUser.username,
      ),
      publicKey: _asymmetricEncryptionService.jsonPublicKey,
    );
    await _userController.pushUser(userDTO);
    await _userController.pushSymmetricEncryptedKeys(base64EncryptedKeys);
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  @override
  Future<void> editInterests({
    required bool private,
    required List<String> interests,
  }) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;
    if (private) {
      privateInfo = currentUser.privateInfo.copyWith(interests: interests);
      _symmetricEncryptionService.generateAndStoreNewKey();
    } else {
      publicInfo = currentUser.publicInfo.copyWith(interests: interests);
    }

    return _updateUser(publicInfo: publicInfo, privateInfo: privateInfo);
  }

  @override
  Future<void> editBio({required bool private, required String bio}) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;
    if (private) {
      privateInfo = currentUser.privateInfo.copyWith(bio: bio);
      _symmetricEncryptionService.generateAndStoreNewKey();
    } else {
      publicInfo = currentUser.publicInfo.copyWith(bio: bio);
    }

    return _updateUser(publicInfo: publicInfo, privateInfo: privateInfo);
  }

  @override
  Future<void> deletePic({required String picId, required bool private}) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;

    if (private) {
      final pictures = [...currentUser.privateInfo.pictures];
      privateInfo = currentUser.privateInfo.copyWith(
        pictures: pictures..removeWhere((element) => element.picId == picId),
      );
    } else {
      final pictures = [...currentUser.publicInfo.pictures];

      publicInfo =
          currentUser.publicInfo.copyWith(pictures: pictures..remove(picId));
    }
    final localUser = LocalUser(
      username: currentUser.username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  @override
  Future<void> addPic({required File pic, required bool private}) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;

    if (private) {
      _symmetricEncryptionService.generateAndStoreNewKey();
      final pics = await _encryptUploadAndRenamePrivatePictures(
        [pic],
        currentUser.username,
        _symmetricEncryptionService,
      );

      final privatePic = PrivatePic(
        picId: pics[0].path,
        keyIndex: _symmetricEncryptionService.lastKeyIndex,
      );
      final pictures = [...currentUser.privateInfo.pictures, privatePic];
      privateInfo = currentUser.privateInfo.copyWith(pictures: pictures);
    } else {
      final pics = await _uploadAndRenamePublicPictures([pic]);
      final pictures = [...currentUser.publicInfo.pictures, pics[0].path];
      publicInfo = currentUser.publicInfo.copyWith(pictures: pictures);
    }
    final localUser = LocalUser(
      username: currentUser.username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  @override
  Future<void> editSexAndOrientation({
    required double sex,
    required bool isSexPrivate,
    required RangeValues searching,
    required bool isSearchingPrivate,
  }) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;
    if (isSexPrivate || isSearchingPrivate) {
      _symmetricEncryptionService.generateAndStoreNewKey();
    }
    if (isSexPrivate) {
      privateInfo = privateInfo.copyWith(sex: () => sex);
      publicInfo = publicInfo.copyWith(sex: () => null);
    } else {
      publicInfo = publicInfo.copyWith(sex: () => sex);
      privateInfo = privateInfo.copyWith(sex: () => null);
    }
    if (isSearchingPrivate) {
      privateInfo = privateInfo.copyWith(searching: () => searching);
      publicInfo = publicInfo.copyWith(searching: () => null);
    } else {
      publicInfo = publicInfo.copyWith(searching: () => searching);
      privateInfo = privateInfo.copyWith(searching: () => null);
    }

    return _updateUser(publicInfo: publicInfo, privateInfo: privateInfo);
  }

  @override
  Future<void> editLocation({
    required double latitude,
    required double longitude,
    required bool private,
  }) async {
    var privateInfo = currentUser.privateInfo;
    var publicInfo = currentUser.publicInfo;
    if (private) {
      privateInfo =
          privateInfo.copyWith(location: () => LatLng(latitude, longitude));
      publicInfo = publicInfo.copyWith(location: () => null);
      _symmetricEncryptionService.generateAndStoreNewKey();
    } else {
      publicInfo =
          publicInfo.copyWith(location: () => LatLng(latitude, longitude));
      privateInfo = privateInfo.copyWith(location: () => null);
    }

    return _updateUser(publicInfo: publicInfo, privateInfo: privateInfo);
  }

  Future<void> _updateUser({
    required PublicInfo publicInfo,
    required PrivateInfo privateInfo,
  }) async {
    final localUser = LocalUser(
      username: currentUser.username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
    final base64EncryptedKeys = await _getEncodedEncryptedKeys();
    final userDTO = UserDTO(
      username: localUser.username,
      publicInfo: localUser.publicInfo.toPublicInfoDTO,
      privateInfo: localUser.privateInfo.toPrivateInfoDTO(
        encryptionService: _symmetricEncryptionService,
        username: localUser.username,
      ),
      publicKey: _asymmetricEncryptionService.jsonPublicKey,
    );
    await _userController.pushUser(userDTO);
    await _userController.pushSymmetricEncryptedKeys(base64EncryptedKeys);
    _currentUser = localUser;
    _userStreamController.add(localUser);
  }

  Future<String> _getEncodedEncryptedKeys() async {
    final keys = _symmetricEncryptionService.loadedKeys;
    final encryptedKeys =
        await _asymmetricEncryptionService.encryptWithLoadedKey(
      json.encode(keys),
    );
    return base64.encode(encryptedKeys.toList());
  }
}

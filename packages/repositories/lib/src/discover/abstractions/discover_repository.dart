import 'dart:io';

import 'package:models/models.dart';

abstract class DiscoverRepository {
  Stream<AddLikeMessage> get receivedLike;
  Stream<RemoveLikeMessage> get receivedRemoveLike;
  Stream<AddLikeMessage> get sendedLike;
  Stream<RemoveLikeMessage> get sendedRemoveLike;
  Stream<Partner> get possiblePartners;
  Future<void> fetch({
    int numberOfPartners = 10,
    List<String> alreadyFetchedUsers = const [],
    Map<String, List<String>> userToKeys = const {},
    dynamic options,
  });
  Future<Partner> fetchPartner({
    required String username,
    List<String>? keys,
  });
  Future<void> putLike({
    required Partner partner,
    required String fromUsername,
  });
  Future<void> removeLike({
    required Partner partner,
    required String fromUsername,
  });
  Future<File> fetchPublicImage({
    required String username,
    required String id,
  });
  Future<File> fetchPrivateImage({
    required String username,
    required String id,
    required String base64Key,
  });
  Partner? getPartnerFromCache({required String username, List<String>? keys});
  File? getPictureFromCache({required String picId, required bool private});
  Map<String, File> getPicturesFromCache({required Partner partner});
  void subscribeToLikeMessages({required String username});
}

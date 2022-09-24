import 'dart:io';

import 'package:controllers/controllers.dart';

abstract class DiscoverController {
  Future<List<UserDTO>> fetchPartners({
    int numberOfPartner,
    List<String> alreadyFetchedUsers,
    dynamic options,
  });
  Future<UserDTO> fetchPartner({
    required String username,
  });
  Future<void> sendSealedLikeMessage({
    required String to,
    required String sealedLikeMessage,
  });
  Future<File> fetchPartnerPublicPicture({
    required String username,
    required String id,
  });
  Future<File> fetchPartnerEncryptedPrivatePicture({
    required String username,
    required String id,
  });
  Future<Map<String, dynamic>> fetchPublicKey({required String username});
}

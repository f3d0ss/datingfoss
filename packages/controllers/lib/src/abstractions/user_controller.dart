import 'dart:io';

import 'package:controllers/controllers.dart';

abstract class UserController {
  Future<UserDTO> fetchUser();
  Future<void> pushUser(UserDTO userDTO);
  Future<String> pushPublicPic(File pic);
  Future<List<File>> fetchPublicPics(List<String> picIds, String username);
  Future<String> pushEncryptedPrivatePic(File encryptedPic, int indexKey);
  Future<List<File>> fetchEncryptedPrivatePics(
    List<String> picIds,
    String username,
  );
  Future<String> fetchSymmetricEncryptedKeys();
  Future<void> pushSymmetricEncryptedKeys(String encryptedKeys);
}

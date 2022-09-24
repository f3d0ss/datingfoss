import 'dart:io';

import 'package:models/models.dart';

abstract class UserRepository {
  Stream<LocalUser> get user;
  LocalUser get currentUser;
  Future<void> signUp({
    required LocalSignupUser signupUser,
  });
  Future<void> logInWithUsernameAndPassword({
    required String username,
    required String password,
  });
  Future<void> logOut();
  Future<bool> isUsernameAvailable(String username) async =>
      !await doesUserExist(username);

  Future<bool> doesUserExist(String username);

  Future<void> editStandardInfo(StandardInfo standardInfo);
  Future<void> editInterests({
    required bool private,
    required List<String> interests,
  });
  Future<void> editBio({required bool private, required String bio});
  Future<void> deletePic({required String picId, required bool private});

  Future<void> addPic({required File pic, required bool private});

  Future<void> editSexAndOrientation({
    required double sex,
    required bool isSexPrivate,
    required RangeValues searching,
    required bool isSearchingPrivate,
  });

  Future<void> editLocation({
    required double latitude,
    required double longitude,
    required bool private,
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_user_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCommunicationHandler extends Mock implements CommunicationHandler {}

void main() {
  group('RestUserController', () {
    late CommunicationHandler communicationHandler;
    late String directoryToStoreFiles;
    setUpAll(() {
      registerFallbackValue(FormData());
    });
    setUp(() {
      communicationHandler = MockCommunicationHandler();
      directoryToStoreFiles = 'dir';
    });

    test('can be instantiated', () {
      expect(
        RestUserController(
          communicationHandler: communicationHandler,
          directoryToStoreFiles: directoryToStoreFiles,
        ),
        isNotNull,
      );
    });

    group('with instantiated RestUserController', () {
      late UserController userController;
      late String baseAction;
      late String username;
      late UserDTO user;
      late Map<String, dynamic> publicKey;
      late String publicPicId;
      late String privatePicId;
      late File encryptedPic;
      late int indexKey;
      late String encryptedKeys;
      setUp(() async {
        userController = RestUserController(
          communicationHandler: communicationHandler,
          directoryToStoreFiles: directoryToStoreFiles,
        );
        baseAction = RestUserController.baseAction;
        username = 'alice';
        publicKey = <String, dynamic>{};
        user = UserDTO(
          username: username,
          publicInfo: const PublicInfoDTO(),
          privateInfo: const PrivateInfoDTO(),
          publicKey: publicKey,
        );
        publicPicId = 'publicPicId';
        privatePicId = 'privatePicId';
        encryptedPic = File('test/test_pic_file/pic_to_update.jpg');
        indexKey = 0;
        encryptedKeys = '';

        when(
          () => communicationHandler.get(
            '$baseAction/SymmetricKeys',
            authenticated: true,
          ),
        ).thenAnswer((_) async => '');
        when(
          () => communicationHandler.get(baseAction, authenticated: true),
        ).thenAnswer((_) async => encodeJson(user.toJson()));

        when(
          () => communicationHandler.post(
            '$baseAction/UploadPrivatePicture',
            any<FormData>(),
            authenticated: true,
          ),
        ).thenAnswer((_) async => {'pictureName': privatePicId});

        when(
          () => communicationHandler.post(
            '$baseAction/UploadPublicPicture',
            any<FormData>(),
            authenticated: true,
          ),
        ).thenAnswer((_) async => {'pictureName': publicPicId});

        when(
          () => communicationHandler.post(
            '$baseAction/UpdateData',
            user.toJson(),
            authenticated: true,
          ),
        ).thenAnswer((_) async {});

        when(
          () => communicationHandler.post(
            '$baseAction/SymmetricKeys',
            '"$encryptedKeys"',
            authenticated: true,
          ),
        ).thenAnswer((_) async {});

        when(
          () => communicationHandler.download(
            any(),
            any(),
            queryParameters: any(named: 'queryParameters'),
            authenticated: any(named: 'authenticated'),
          ),
        ).thenAnswer((_) async {});
      });

      test('can fetchPublicPics', () {
        userController.fetchPublicPics([publicPicId], username);
      });

      test('can fetchEncryptedPrivatePics', () {
        userController.fetchEncryptedPrivatePics([privatePicId], username);
      });

      test('can fetchUser', () {
        userController.fetchUser();
      });

      test('can pushEncryptedPrivatePic', () {
        userController.pushEncryptedPrivatePic(encryptedPic, indexKey);
      });
      test('can pushPublicPic', () {
        userController.pushPublicPic(encryptedPic);
      });

      test('can pushUser', () {
        userController.pushUser(user);
      });

      test('can fetchSymmetricEncryptedKeys', () {
        userController.fetchSymmetricEncryptedKeys();
      });

      test('can pushSymmetricEncryptedKeys', () {
        userController.pushSymmetricEncryptedKeys(encryptedKeys);
      });
    });
  });
}

dynamic encodeJson(Map<String, dynamic> jsonObject) =>
    json.decode(json.encode(jsonObject));

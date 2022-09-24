import 'dart:convert';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_authentication_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCommunicationHandler extends Mock implements CommunicationHandler {}

void main() {
  group('RestAuthenticationController', () {
    late CommunicationHandler communicationHandler;
    setUp(() {
      communicationHandler = MockCommunicationHandler();
    });

    test('can be instantiated', () {
      expect(
        RestAuthenticationController(
          communicationHandler: communicationHandler,
        ),
        isNotNull,
      );
    });

    test('can instantiate AuthException', () {
      expect(AuthException(code: ''), isNotNull);
    });

    group('with instantiated RestAuthenticationController', () {
      late AuthenticationController authenticationController;
      late String username;
      late String baseAction;
      late TokenDTO tokenDTO;
      late List<int> signedChallenge;
      late Map<String, String> jwt;
      late Map<String, String> publicKey;
      setUp(() {
        authenticationController = RestAuthenticationController(
          communicationHandler: communicationHandler,
        );
        username = 'alice';
        baseAction = RestAuthenticationController.baseAction;
        tokenDTO = TokenDTO(Challenge('d', username, 'exp'), 'sst');
        signedChallenge = [];
        jwt = {'jwt': 'xxx'};
        publicKey = {};

        final queryParamGetChallenge = {'username': username};
        when(
          () => communicationHandler.get(
            '$baseAction/GetChallenge',
            queryParameters: queryParamGetChallenge,
          ),
        ).thenAnswer((_) async => encodeJson(tokenDTO.toJson()));
        final loginRequest = {
          'token': tokenDTO,
          'dataSignedFromClient': base64.encode(signedChallenge),
        };
        when(
          () => communicationHandler.post('$baseAction/LogIn', loginRequest),
        ).thenAnswer((_) async => encodeJson(jwt));
        final signUpRequest = {'username': username, 'publicKey': publicKey};
        when(
          () => communicationHandler.post('$baseAction/SignUp', signUpRequest),
        ).thenAnswer((_) async => encodeJson(jwt));
        final doesUserExistRequest = {'username': username};
        when(
          () => communicationHandler.get(
            '$baseAction/DoesUserExist',
            queryParameters: doesUserExistRequest,
          ),
        ).thenAnswer((_) async => true);
      });

      test('can getLoginChallenge', () {
        authenticationController.getLoginChallenge(username: username);
      });

      test('can logIn', () {
        authenticationController.logIn(
          username: username,
          token: tokenDTO,
          signedChallenge: signedChallenge,
        );
      });

      test('can signUp', () {
        authenticationController.signUp(
          username: username,
          publicKey: publicKey,
        );
      });

      test('can logOut', () {
        authenticationController.logOut();
      });

      test('can doesUserExist', () {
        authenticationController.doesUserExist(username);
      });
    });
  });
}

dynamic encodeJson(Map<String, dynamic> jsonObject) =>
    json.decode(json.encode(jsonObject));

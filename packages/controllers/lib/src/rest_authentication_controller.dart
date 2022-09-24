import 'dart:async';
import 'dart:convert';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';

class RestAuthenticationController extends AuthenticationController {
  RestAuthenticationController({
    required CommunicationHandler communicationHandler,
  }) : _communicationHandler = communicationHandler;

  static const baseAction = 'Authorization';
  final CommunicationHandler _communicationHandler;

  @override
  Future<TokenDTO> getLoginChallenge({required String username}) async {
    final queryParams = {'username': username};
    final jsonToken = await _communicationHandler.get(
      '$baseAction/GetChallenge',
      queryParameters: queryParams,
    ) as Map<String, dynamic>;
    return TokenDTO.fromJson(jsonToken);
  }

  @override
  Future<void> logIn({
    required String username,
    required List<int> signedChallenge,
    required TokenDTO token,
  }) async {
    final loginRequest = {
      'token': token,
      'dataSignedFromClient': base64.encode(signedChallenge),
    };
    final response = await _communicationHandler.post(
      '$baseAction/LogIn',
      loginRequest,
    ) as Map<String, dynamic>;

    _communicationHandler.setToken(
      accessToken: response['jwt'] as String,
      refreshToken: (response['refreshToken'] ?? '') as String,
    );
    return;
  }

  @override
  Future<void> signUp({
    required String username,
    required Map<String, dynamic> publicKey,
  }) async {
    final signUpRequest = {'username': username, 'publicKey': publicKey};

    final response = await _communicationHandler.post(
      '$baseAction/SignUp',
      signUpRequest,
    ) as Map<String, dynamic>;
    _communicationHandler.setToken(
      accessToken: response['jwt'] as String,
      refreshToken: (response['refreshToken'] ?? '') as String,
    );
  }

  @override
  Future<void> logOut() async => _communicationHandler.unsetToken();

  @override
  Future<bool> doesUserExist(String username) async =>
      await _communicationHandler.get(
        '$baseAction/DoesUserExist',
        queryParameters: <String, String>{'username': username},
      ) as bool;
}

class AuthException implements Exception {
  AuthException({
    this.message,
    required this.code,
    this.username,
    this.password,
  });

  final String? message;
  final String code;
  final String? username;
  final String? password;
}

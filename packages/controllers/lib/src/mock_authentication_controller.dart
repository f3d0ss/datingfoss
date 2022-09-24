import 'dart:async';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';

class MockAuthenticationController extends AuthenticationController {
  MockAuthenticationController({
    required CommunicationHandler communicationHandler,
  }) : _communicationHandler = communicationHandler;

  static const baseAction = 'Authorization';
  final CommunicationHandler _communicationHandler;

  @override
  Future<TokenDTO> getLoginChallenge({required String username}) async {
    return TokenDTO(
      Challenge('signThis', 'username', 'expirationDate'),
      'ServerSignedToken',
    );
  }

  @override
  Future<void> logIn({
    required String username,
    required List<int> signedChallenge,
    required TokenDTO token,
  }) async {
    _communicationHandler.setToken(
      accessToken: '''
eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiZ3JldmUwMCIsIlB1YmxpY0tleSI6IntcIk1vZHVsdXNcIjpcImd0VXpaVTRwM1l3L2ROMWJKcUlDNzd3OWczbld6ZGdEODlqejlBOHU4RmZtNE5hTjh4cFdpUEpFSUlqNzAzQi9aaFA2R2txQmFRU0plMWxkZWE5OHdhSlxcdTAwMkJpYmhaekZLa1RPUmFneFB5aS9qcDFxRFpiRUwxQ28vU0NqVkptXFx1MDAyQlg1TkprVmpnTUJsalZFUU5KSFNcXHUwMDJCNGptXFx1MDAyQll0UnNseFNJTDZRL3k5LzVQc3hVUlg4NFdLNzFiNVVIakxtc0tKR1J1WVcvZDh5Q3JWL3lmdFdYT1gxUzNtUXp3a2RBbTNrUFFZQ0tUcFFyQWtzSkFEc1ZXUHNzT28zTmQvNnFzR09ocHZMbTJQcUhnSktucDNrOGlza215WmI2UnMvVXJUNTFycmRvXFx1MDAyQldhSWR6UjRuT0N0alRWa3pXSzJoSGJxOXFMQ3FoS1RKMlJTT2FOMTJVR3pUNDlYdWV1UT09XCIsXCJFeHBvbmVudFwiOlwiQVFBQlwifSIsImV4cCI6MTY2NjE1NTU2MCwiaXNzIjoiaXNzdWVyIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAyLyJ9.0AjFcqwFqI4AnAdZ6VcK4kgBJ_OLZAFDasKWG5i0gM0''',
      refreshToken: '',
    );
    return;
  }

  @override
  Future<void> signUp({
    required String username,
    required Map<String, dynamic> publicKey,
  }) async {
    _communicationHandler.setToken(
      accessToken: '''
eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiZ3JldmUwMCIsIlB1YmxpY0tleSI6IntcIk1vZHVsdXNcIjpcImd0VXpaVTRwM1l3L2ROMWJKcUlDNzd3OWczbld6ZGdEODlqejlBOHU4RmZtNE5hTjh4cFdpUEpFSUlqNzAzQi9aaFA2R2txQmFRU0plMWxkZWE5OHdhSlxcdTAwMkJpYmhaekZLa1RPUmFneFB5aS9qcDFxRFpiRUwxQ28vU0NqVkptXFx1MDAyQlg1TkprVmpnTUJsalZFUU5KSFNcXHUwMDJCNGptXFx1MDAyQll0UnNseFNJTDZRL3k5LzVQc3hVUlg4NFdLNzFiNVVIakxtc0tKR1J1WVcvZDh5Q3JWL3lmdFdYT1gxUzNtUXp3a2RBbTNrUFFZQ0tUcFFyQWtzSkFEc1ZXUHNzT28zTmQvNnFzR09ocHZMbTJQcUhnSktucDNrOGlza215WmI2UnMvVXJUNTFycmRvXFx1MDAyQldhSWR6UjRuT0N0alRWa3pXSzJoSGJxOXFMQ3FoS1RKMlJTT2FOMTJVR3pUNDlYdWV1UT09XCIsXCJFeHBvbmVudFwiOlwiQVFBQlwifSIsImV4cCI6MTY2NjE1NTU2MCwiaXNzIjoiaXNzdWVyIiwiYXVkIjoiaHR0cDovL2xvY2FsaG9zdDo1MDAyLyJ9.0AjFcqwFqI4AnAdZ6VcK4kgBJ_OLZAFDasKWG5i0gM0''',
      refreshToken: '',
    );
  }

  @override
  Future<void> logOut() async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    _communicationHandler.unsetToken();
  }

  @override
  Future<bool> doesUserExist(String username) async {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    return true;
  }
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

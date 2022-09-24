import 'package:controllers/controllers.dart';

abstract class AuthenticationController {
  Future<TokenDTO> getLoginChallenge({required String username});
  Future<void> logIn({
    required String username,
    required TokenDTO token,
    required List<int> signedChallenge,
  });
  Future<void> signUp({
    required String username,
    required Map<String, dynamic> publicKey,
  });
  Future<void> logOut();
  Future<bool> doesUserExist(String username);
}

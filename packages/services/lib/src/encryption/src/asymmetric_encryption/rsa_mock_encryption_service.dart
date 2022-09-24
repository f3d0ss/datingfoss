part of 'rsa_encryption_service.dart';

class RSAMockEncryptionService extends RSAEncryptionService {
  @override
  Future<void> createKeyPair(String username, String password) async {
    return super.createKeyPair('greve00', 'greve00');
  }
}

abstract class AsymmetricEncryptionService {
  Map<String, dynamic> get jsonPublicKey;
  Future<void> createKeyPair(String username, String password);
  Future<List<int>> sign(String dataToSign);
  bool verifySignature(
    Map<String, dynamic> jsonPublicKey,
    String clearText,
    List<int> signature,
  );
  Future<List<int>> encrypt(
    String plainText,
    Map<String, dynamic> jsonPublicKey,
  );
  Future<List<int>> encryptWithLoadedKey(String plainText);
  Future<String> decrypt(List<int> cipherText);
}

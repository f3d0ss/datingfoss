import 'dart:io';

abstract class SymmetricEncryptionService {
  /// load keys in the library
  void loadKey(List<String> keys);
  void generateAndStoreNewKey();
  List<String> get loadedKeys;
  int get lastKeyIndex;
  String encrypt({
    required String plainText,
    required String base64Key,
    required String username,
  });
  List<int> encryptBytes({
    required List<int> bytes,
    required String base64Key,
    required String username,
  });
  String encryptWithLastKey({
    required String plainText,
    required String username,
  });
  List<int> encryptBytesWithLastKey({
    required List<int> bytes,
    required String username,
  });
  String decrypt({
    required String base64Encoded,
    required String base64Key,
    required String username,
  });
  List<int> decryptBytes({
    required List<int> bytes,
    required String base64Key,
    required String username,
  });
  String decryptWithLoadedKey({
    required String base64Encoded,
    required int index,
    required String username,
  });
  List<int> decryptBytesWithLoadedKey({
    required List<int> bytes,
    required int index,
    required String username,
  });
  Future<File> encryptFile({
    required File inputFile,
    required String username,
    required String newFilePath,
  });
  Future<File> decryptFileWithLoadedKey({
    required File inputFile,
    required String username,
    required String newFilePath,
    required int keyIndex,
  });
  Future<File> decryptFile({
    required File inputFile,
    required String username,
    required String newFilePath,
    required String base64Key,
  });
}

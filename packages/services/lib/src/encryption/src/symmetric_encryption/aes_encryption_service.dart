import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:services/services.dart';

class AESEncryptionService extends SymmetricEncryptionService {
  AESEncryptionService();

  final List<String> _loadedKeys = [];

  @override
  String decrypt({
    required String base64Encoded,
    required String base64Key,
    required String username,
  }) {
    final bytes = base64.decode(base64Encoded);
    final decrypted = decryptBytes(
      bytes: bytes,
      base64Key: base64Key,
      username: username,
    );
    return utf8.decode(decrypted, allowMalformed: true);
  }

  @override
  List<int> decryptBytes({
    required List<int> bytes,
    required String base64Key,
    required String username,
  }) {
    final key = Key.fromBase64(base64Key);
    final iv = IV.fromUtf8(username);

    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted(Uint8List.fromList(bytes));
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
    return decrypted;
  }

  @override
  String decryptWithLoadedKey({
    required String base64Encoded,
    required int index,
    required String username,
  }) {
    final base64Key = loadedKeys[index];

    final decrypted = decrypt(
      base64Encoded: base64Encoded,
      base64Key: base64Key,
      username: username,
    );

    return decrypted;
  }

  @override
  List<int> decryptBytesWithLoadedKey({
    required List<int> bytes,
    required int index,
    required String username,
  }) {
    final base64Key = loadedKeys[index];

    final decrypted = decryptBytes(
      bytes: bytes,
      base64Key: base64Key,
      username: username,
    );

    return decrypted;
  }

  @override
  String encrypt({
    required String plainText,
    required String base64Key,
    required String username,
  }) {
    final bytes = utf8.encode(plainText);
    final encrypted = encryptBytes(
      bytes: bytes,
      username: username,
      base64Key: base64Key,
    );
    return base64.encode(encrypted);
  }

  @override
  List<int> encryptBytes({
    required List<int> bytes,
    required String base64Key,
    required String username,
  }) {
    final key = Key.fromBase64(base64Key);
    final iv = IV.fromUtf8(username);

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encryptBytes(bytes, iv: iv);
    return encrypted.bytes;
  }

  @override
  String encryptWithLastKey({
    required String plainText,
    required String username,
  }) {
    final base64Key = loadedKeys[lastKeyIndex];
    final encrypted = encrypt(
      base64Key: base64Key,
      plainText: plainText,
      username: username,
    );

    return encrypted;
  }

  @override
  List<int> encryptBytesWithLastKey({
    required List<int> bytes,
    required String username,
  }) {
    final base64Key = loadedKeys[lastKeyIndex];
    return encryptBytes(
      bytes: bytes,
      base64Key: base64Key,
      username: username,
    );
  }

  @override
  Future<File> encryptFile({
    required File inputFile,
    required String username,
    required String newFilePath,
  }) async {
    final fileBytes = await inputFile.readAsBytes();
    final encryptedFile = encryptBytesWithLastKey(
      bytes: fileBytes,
      username: username,
    );
    return File(newFilePath).writeAsBytes(encryptedFile);
  }

  @override
  Future<File> decryptFileWithLoadedKey({
    required File inputFile,
    required String username,
    required String newFilePath,
    required int keyIndex,
  }) async {
    final base64Key = loadedKeys[keyIndex];
    return decryptFile(
      inputFile: inputFile,
      username: username,
      newFilePath: newFilePath,
      base64Key: base64Key,
    );
  }

  @override
  Future<File> decryptFile({
    required File inputFile,
    required String username,
    required String newFilePath,
    required String base64Key,
  }) async {
    final fileBytes = await inputFile.readAsBytes();
    final decryptedBytes = decryptBytes(
      bytes: fileBytes,
      base64Key: base64Key,
      username: username,
    );
    final decryptedFile = await File(newFilePath).create(recursive: true);
    return decryptedFile.writeAsBytes(decryptedBytes);
  }

  @override
  void generateAndStoreNewKey() {
    final newkey = Key.fromSecureRandom(32);
    _loadedKeys.add(newkey.base64);
  }

  @override
  void loadKey(List<String> keys) {
    _loadedKeys
      ..clear()
      ..addAll(keys);
  }

  @override
  List<String> get loadedKeys => [..._loadedKeys];

  @override
  int get lastKeyIndex => _loadedKeys.length - 1;
}

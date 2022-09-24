import 'dart:io';

import 'package:services/src/encryption/src/symmetric_encryption/aes_encryption_service.dart';
import 'package:test/test.dart';

void main() {
  group('SymmetricEncryptionService', () {
    test('can be instantiated', () {
      expect(AESEncryptionService(), isNotNull);
    });

    group('with instantiated AESEncryptionService', () {
      late AESEncryptionService aesEncryptionService;
      setUp(() {
        aesEncryptionService = AESEncryptionService();
      });
      test('can createKey', () {
        aesEncryptionService.generateAndStoreNewKey();
        final numberOfKeys = aesEncryptionService.loadedKeys.length;
        expect(numberOfKeys, 1);
      });

      test('can loadKeys', () {
        final keys = ['key1', 'key2'];
        aesEncryptionService.loadKey(keys);
        expect(aesEncryptionService.loadedKeys, keys);
      });

      group('with a key generated', () {
        setUp(() {
          aesEncryptionService.generateAndStoreNewKey();
        });

        const dataToBeEncrypt = 'Data To Be Encrypt';
        const username = 'alice';
        test('can encrypt and decrypt String with stored keys', () async {
          final dataEncrypted = aesEncryptionService.encryptWithLastKey(
            plainText: dataToBeEncrypt,
            username: username,
          );
          expect(dataEncrypted, isNot(dataToBeEncrypt));
          final indexLastKey = aesEncryptionService.lastKeyIndex;
          final dataBackToClear = aesEncryptionService.decryptWithLoadedKey(
            base64Encoded: dataEncrypted,
            index: indexLastKey,
            username: username,
          );
          expect(dataBackToClear, dataToBeEncrypt);
        });

        const bytesToBeEncrypt = [0, 1, 2, 3];
        test('can encrypt and decrypt Bytes with stored keys', () async {
          final bytesEncrypted = aesEncryptionService.encryptBytesWithLastKey(
            bytes: bytesToBeEncrypt,
            username: username,
          );
          expect(bytesEncrypted, isNot(dataToBeEncrypt));
          final indexLastKey = aesEncryptionService.lastKeyIndex;
          final bytesBackToClear =
              aesEncryptionService.decryptBytesWithLoadedKey(
            bytes: bytesEncrypted,
            index: indexLastKey,
            username: username,
          );
          expect(bytesBackToClear, bytesToBeEncrypt);
        });

        const externalKey = 'KEY_SUPER_ULTRA_IPER_MEGA_SECURE';
        const externalUsername = 'bob';
        test('can encrypt and decrypt data with external Key', () async {
          final dataEncrypted = aesEncryptionService.encrypt(
            plainText: dataToBeEncrypt,
            base64Key: externalKey,
            username: externalUsername,
          );
          expect(dataEncrypted, isNot(dataToBeEncrypt));
          final dataBackToClear = aesEncryptionService.decrypt(
            base64Encoded: dataEncrypted,
            base64Key: externalKey,
            username: externalUsername,
          );
          expect(dataBackToClear, dataToBeEncrypt);
        });

        group('using file', () {
          final rootDir = Directory.current;
          final basePath = '${rootDir.path}/test/.temp_file';
          setUpAll(() async {
            final directory = Directory(basePath);
            // ignore: avoid_slow_async_io
            if (await directory.exists()) {
            } else {
              return directory.create();
            }
          });
          tearDown(() {
            Directory(basePath).deleteSync(recursive: true);
          });
          test('can encrypt and decrypt a file', () async {
            final randomFile = await File('$basePath/inital.txt').create()
              ..writeAsStringSync('This is the content of the file');
            final encryptedFile = await aesEncryptionService.encryptFile(
              inputFile: randomFile,
              newFilePath: '$basePath/encrypted.txt',
              username: externalUsername,
            );
            expect(
              encryptedFile.readAsBytesSync(),
              isNot(randomFile.readAsBytesSync()),
            );
            final indexLastKey = aesEncryptionService.lastKeyIndex;
            final fileBackToClear =
                await aesEncryptionService.decryptFileWithLoadedKey(
              inputFile: encryptedFile,
              newFilePath: '$basePath/clear.txt',
              username: externalUsername,
              keyIndex: indexLastKey,
            );
            expect(
              fileBackToClear.readAsStringSync(),
              randomFile.readAsStringSync(),
            );
          });
        });
      });
    });
  });
}

// ignore_for_file: prefer_const_constructors
import 'package:services/src/encryption/src/asymmetric_encryption/rsa_encryption_service.dart';
import 'package:test/test.dart';

void main() {
  group('RSAEncryptionService', () {
    test('can be instantiated', () {
      expect(RSAEncryptionService(), isNotNull);
    });

    group('with instantiated RSAEncryptionService', () {
      late RSAEncryptionService rsaEncryptionService;
      setUp(() {
        rsaEncryptionService = RSAEncryptionService();
      });
      test('can createKeyPair', () {
        rsaEncryptionService.createKeyPair('username', 'password');
      });

      group('with key pair generated', () {
        setUp(() {
          rsaEncryptionService.createKeyPair('username', 'password');
        });

        const dataToBeSigned = 'Data To Be Signed';
        test('can sign and verify data', () async {
          final dataSigned = await rsaEncryptionService.sign(dataToBeSigned);
          final publicKey = rsaEncryptionService.jsonPublicKey;
          final verification = rsaEncryptionService.verifySignature(
            publicKey,
            dataToBeSigned,
            dataSigned,
          );
          expect(verification, isTrue);
        });

        test('return false when signature is not right', () async {
          final dataSigned = await rsaEncryptionService.sign(dataToBeSigned);
          final publicKey = rsaEncryptionService.jsonPublicKey;
          final verification = rsaEncryptionService.verifySignature(
            publicKey,
            dataToBeSigned,
            [...dataSigned]..replaceRange(1, 2, [0]),
          );
          expect(verification, isFalse);
        });

        const dataToBeEncrypted = 'Data To Be Encrypted';
        test('can encrypt and decrypt data', () async {
          final encryptedData = await rsaEncryptionService
              .encryptWithLoadedKey(dataToBeEncrypted);
          final decryptedData =
              await rsaEncryptionService.decrypt(encryptedData);
          expect(decryptedData, dataToBeEncrypted);
        });
      });
    });
  });
}

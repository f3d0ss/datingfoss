import 'dart:typed_data';
import 'package:ninja/ninja.dart' as ninja;
import 'package:pointycastle/export.dart';
import 'package:services/services.dart';

part 'rsa_mock_encryption_service.dart';

class RSAEncryptionService implements AsymmetricEncryptionService {
  RSAEncryptionService();

  final BigInt _publicExponent = BigInt.parse('65537');
  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _asymmetricKeyPair;

  @override
  Map<String, dynamic> get jsonPublicKey {
    return _asymmetricKeyPair.publicKey.toJson();
  }

  @override
  Future<void> createKeyPair(String username, String password) async {
    final userPassPlain = '$username$password';
    final userPassCodeUnits = userPassPlain.codeUnits;
    final userPassUint8List = Uint8List.fromList(userPassCodeUnits);
    final seed = SHA256Digest().process(userPassUint8List);
    final pair = _generateRSAkeyPair(_generateRandomFromSeed(seed));
    _asymmetricKeyPair = pair;
  }

  @override
  Future<List<int>> sign(String dataToSign) async {
    final signer = RSASigner(
      SHA256Digest(),
      '0609608648016503040201',
    ); //0609608648016503040201 is the algorithm identifier
    final pair = _asymmetricKeyPair;
    final private = pair.privateKey;
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(private));
    final sig =
        signer.generateSignature(Uint8List.fromList(dataToSign.codeUnits));
    return sig.bytes;
  }

  @override
  bool verifySignature(
    Map<String, dynamic> jsonPublicKey,
    String clearText,
    List<int> signature,
  ) {
    final sig = RSASignature(Uint8List.fromList(signature));

    final publicKey = _rsaPublicKeyfromJson(jsonPublicKey);

    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201')
      ..init(
        false,
        PublicKeyParameter<RSAPublicKey>(publicKey),
      );

    try {
      return verifier.verifySignature(
        Uint8List.fromList(clearText.codeUnits),
        sig,
      );
      // ignore: avoid_catching_errors
    } on ArgumentError {
      return false; // for Pointy Castle 1.0.2 when signature has been modified
    }
  }

  @override
  Future<List<int>> encrypt(
    String plainText,
    Map<String, dynamic> jsonPublicKey,
  ) async {
    final publicKey = _rsaPublicKeyfromJson(jsonPublicKey);
    final cipherText =
        _rsaEncrypt(publicKey, Uint8List.fromList(plainText.codeUnits));
    return cipherText;
  }

  @override
  Future<List<int>> encryptWithLoadedKey(String plainText) {
    return encrypt(plainText, jsonPublicKey);
  }

  @override
  Future<String> decrypt(List<int> cipherText) async {
    final pair = _asymmetricKeyPair;
    final private = pair.privateKey;
    final backToPlaintext =
        _rsaDecrypt(private, Uint8List.fromList(cipherText));
    return String.fromCharCodes(backToPlaintext);
  }

  //Utils

  Uint8List _rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List _rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(
        false,
        PrivateKeyParameter<RSAPrivateKey>(myPrivate),
      );

    return _processInBlocks(decryptor, cipherText);
  }

  Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
        input,
        inputOffset,
        chunkSize,
        output,
        outputOffset,
      );

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }

  SecureRandom _generateRandomFromSeed(Uint8List seed) {
    final secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(seed));
    return secureRandom;
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRSAkeyPair(
    SecureRandom secureRandom, {
    int bitLength = 2048,
  }) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
          RSAKeyGeneratorParameters(_publicExponent, bitLength, 64),
          secureRandom,
        ),
      );

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  RSAPublicKey _rsaPublicKeyfromJson(Map<String, dynamic> jsonPublicKey) {
    // ignore: avoid_dynamic_calls
    final modulus = ninja.base64ToBigInt(jsonPublicKey['modulus'] as String);
    // ignore: avoid_dynamic_calls
    final publicExponent =
        ninja.base64ToBigInt(jsonPublicKey['exponent'] as String);
    return RSAPublicKey(modulus, publicExponent);
  }
}

extension on RSAPublicKey {
  Map<String, dynamic> toJson() {
    final jsonPublicKey = {
      'exponent': ninja.bigIntToBase64(publicExponent!),
      'modulus': ninja.bigIntToBase64(modulus!),
    };
    return jsonPublicKey;
  }
}

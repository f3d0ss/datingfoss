import 'dart:convert';

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('TokenDTO', () {
    const json = '''
        {
          "challenge": {
            "dataToSign": "dataToSign",
            "username": "beautifulUsername",
            "expirationDate": "2022-03-17T18:58:42.162Z"
          },
          "serverSignedToken": "signedToken"
        }
      ''';
    test('can be instantiated from json', () {
      final tokenDTO =
          TokenDTO.fromJson(jsonDecode(json) as Map<String, dynamic>);
      expect(tokenDTO.serverSignedToken, 'signedToken');
      final challenge = tokenDTO.challenge;
      expect(challenge.dataToSign, 'dataToSign');
      expect(challenge.username, 'beautifulUsername');
      expect(challenge.expirationDate, '2022-03-17T18:58:42.162Z');
    });
  });
}

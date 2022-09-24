import 'dart:convert';
import 'dart:developer';

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('UserDTO', () {
    test('can be converted to json', () {
      final userDTO = UserDTO(
        username: 'pippo',
        publicInfo: PublicInfoDTO(
          bio: 'supaBio',
          location: const LocationDTO(12, 12),
          boolInfo: const {'fuamtore': false},
          textInfo: const {'altezza': '120cm'},
          dateInfo: {'first': DateTime.now()},
          interests: const ['banana', 'ananas'],
          pictures: const ['pic', 'dic'],
          searching: const RangeValuesDTO(0, 1),
          sex: 0.2,
        ),
        privateInfo: const PrivateInfoDTO(
          bio: EncryptedDataDTO('string', 1),
          boolInfo: EncryptedDataDTO('string', 1),
          dateInfo: EncryptedDataDTO('string', 1),
          interests: EncryptedDataDTO('string', 1),
          location: EncryptedDataDTO('string', 1),
          pictures: [],
          searching: EncryptedDataDTO('string', 1),
          sex: EncryptedDataDTO('string', 1),
          textInfo: EncryptedDataDTO('string', 1),
        ),
        publicKey: <String, String>{
          'modulus':
              'wUdGPuo1iBZs3qWYl+ytEXFlTMKHjuDdrg+E9CrfB9II4uueiUQc5Vtj0X2sTL1tRQMA9ArLbtQcd/M50rwjo7++Rk4UDL2fEAH30QIWb8sv4hIJbUfisW1IOGLLJ1hCtG9nmJ5dxlkxvxYTaJCQxd7f9b86KcENaNox6SVI/Hk=',
          'exponent': 'AQAB'
        },
      );
      log(json.encode({'user': userDTO}));
    });

    test('can be instantiated from json', () {
      const userDTOJson = '''{
            "username": "pippo",
            "publicKey": {
              "modulus": "wUdGPuo1iBZs3qWYl+ytEXFlTMKHjuDdrg+E9CrfB9II4uueiUQc5Vtj0X2sTL1tRQMA9ArLbtQcd/M50rwjo7++Rk4UDL2fEAH30QIWb8sv4hIJbUfisW1IOGLLJ1hCtG9nmJ5dxlkxvxYTaJCQxd7f9b86KcENaNox6SVI/Hk=",
              "exponent": "AQAB"
            },
            "encryptedKeys": "",
            "encryptedPartnerThatILike": "",
            "publicInfo": {
              "sex": 0.2,
              "location": {
                "latitude": 12,
                "longitude": 12
              },
              "bio": "supaBio",
              "textInfo": {
                "altezza": "120cm"
              },
              "boolInfo": {
                "fuamtore": true
              },
              "dateInfo": {
                "first": "2022-03-24T07:53:26.564Z"
              },
              "interests": [
                "banana",
                "ananas"
              ],
              "pictures": [
                "pic",
                "dic"
              ],
              "searching": {
                "start": 0,
                "end": 1
              }
            },
            "privateInfo": {
              "sex": {
                "encoded": "string",
                "keyIndex": 0
              },
              "position": {
                "encoded": "string",
                "keyIndex": 0
              },
              "bio": {
                "encoded": "string",
                "keyIndex": 0
              },
              "textInfo": {
                "encoded": "string",
                "keyIndex": 0
              },
              "boolInfo": {
                "encoded": "string",
                "keyIndex": 0
              },
              "dateInfo": {
                "encoded": "string",
                "keyIndex": 0
              },
              "interests": {
                "encoded": "string",
                "keyIndex": 0
              },
              "pictures": [],
              "searching": {
                "encoded": "string",
                "keyIndex": 0
              }
            }
          
        }''';
      UserDTO.fromJson(
        json.decode(userDTOJson) as Map<String, dynamic>,
      );
    });
  });
}

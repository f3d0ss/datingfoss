// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('PrivateInfoDTO', () {
    late PrivateInfoDTO privateInfoDTO;
    setUp(() {
      privateInfoDTO = PrivateInfoDTO();
    });
    test('can compare', () {
      expect(privateInfoDTO, PrivateInfoDTO());
    });

    test('can get pictureIds', () {
      privateInfoDTO.pictureIds;
    });
  });
}

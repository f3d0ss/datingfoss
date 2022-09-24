// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('PublicInfoDTO', () {
    late PublicInfoDTO publicInfoDTO;
    setUp(() {
      publicInfoDTO = PublicInfoDTO();
    });
    test('can compare', () {
      expect(publicInfoDTO, PublicInfoDTO());
    });
  });
}

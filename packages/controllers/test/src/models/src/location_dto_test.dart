// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('LocationDTO', () {
    late LocationDTO locationDTO;
    setUp(() {
      locationDTO = LocationDTO(0, 0);
    });
    test('can compare', () {
      expect(locationDTO, LocationDTO(0, 0));
    });
  });
}

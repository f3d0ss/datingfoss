// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('RangeValuesDTO', () {
    late RangeValuesDTO rangeValueDTO;
    setUp(() {
      rangeValueDTO = RangeValuesDTO(0, 1);
    });
    test('can compare', () {
      expect(rangeValueDTO, RangeValuesDTO(0, 1));
    });
  });
}

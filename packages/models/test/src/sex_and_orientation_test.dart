// ignore_for_file: prefer_const_constructors

import 'package:models/src/range_value.dart';
import 'package:models/src/sex_and_orientation.dart';
import 'package:models/src/signup/private_data.dart';
import 'package:test/test.dart';

void main() {
  group('SexAndOrientation', () {
    test('can be compared', () {
      expect(
        SexAndOrientation(
          sex: PrivateData(0),
          searching: PrivateData(RangeValues(0, 1)),
        ),
        SexAndOrientation(
          sex: PrivateData(0),
          searching: PrivateData(RangeValues(0, 1)),
        ),
      );
    });
  });
}

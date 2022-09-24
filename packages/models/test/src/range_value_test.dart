import 'package:models/src/range_value.dart';
import 'package:test/test.dart';

void main() {
  group('RangeValues', () {
    test('can go to json and back', () {
      const message = RangeValues(0, 1);
      expect(message, RangeValues.fromJson(message.toJson()));
    });
  });
}

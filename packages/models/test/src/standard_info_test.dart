import 'package:models/src/standard_info.dart';
import 'package:test/test.dart';

void main() {
  group('StandardInfo', () {
    test('can be istantiated', () {
      expect(
        const StandardInfo(textInfo: {}, boolInfo: {}, dateInfo: {}),
        isNotNull,
      );
    });
  });
}

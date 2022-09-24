import 'package:models/src/commonable_interest.dart';
import 'package:test/test.dart';

void main() {
  group('CommonableInterest', () {
    test('can be istantiated', () {
      expect(const CommonableInterest('', common: true), isNotNull);
    });
  });
}

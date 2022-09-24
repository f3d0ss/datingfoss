import 'package:models/src/signup/bool_info.dart';
import 'package:models/src/signup/private_data.dart';
import 'package:test/test.dart';

void main() {
  group('BoolInfo', () {
    test('can be istantiated', () {
      expect(const BoolInfo(PrivateData(true)), isNotNull);
    });

    group('with BoolInfo istantiated', () {
      late BoolInfo boolInfo;
      setUp(() {
        boolInfo = const BoolInfo(PrivateData(false));
      });
      test('can get error', () {
        boolInfo.error;
      });
    });
  });
}

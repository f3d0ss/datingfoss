import 'package:models/src/signup/date_info.dart';
import 'package:models/src/signup/private_data.dart';
import 'package:test/test.dart';

void main() {
  group('DateInfo', () {
    late PrivateData<DateTime> privateData;
    setUp(() {
      privateData = PrivateData(DateTime(1990));
    });
    test('can be istantiated as pure', () {
      expect(DateInfo.pure(privateData), isNotNull);
    });

    test('can be istantiated as dirty', () {
      expect(DateInfo.dirty(privateData), isNotNull);
    });

    group('with DateInfo istantiated', () {
      late DateInfo dateInfo;
      late DateInfo emptyDateInfo;
      setUp(() {
        dateInfo = DateInfo.pure(privateData.copyWith());
        emptyDateInfo = const DateInfo.dirty(PrivateData(null));
      });
      test('can get error', () {
        dateInfo.error;
        emptyDateInfo.error;
      });
    });
  });
}

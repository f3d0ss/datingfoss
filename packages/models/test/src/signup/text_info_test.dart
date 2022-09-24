import 'package:models/src/signup/private_data.dart';
import 'package:models/src/signup/text_info.dart';
import 'package:test/test.dart';

void main() {
  group('TextInfo', () {
    test('can be istantiated as pure', () {
      expect(const TextInfo.pure(PrivateData('text')), isNotNull);
    });

    test('can be istantiated as dirty', () {
      expect(const TextInfo.dirty(PrivateData('text')), isNotNull);
    });

    group('with TextInfo istantiated', () {
      late TextInfo textInfo;
      late TextInfo emptyTextInfo;
      setUp(() {
        textInfo = const TextInfo.pure(PrivateData('text'));
        emptyTextInfo = const TextInfo.dirty(PrivateData(''));
      });
      test('can get error', () {
        textInfo.error;
        emptyTextInfo.error;
      });

      test('can get text if not private', () {
        expect(textInfo.data.getIf(ifPrivate: false), 'text');
      });
    });
  });
}

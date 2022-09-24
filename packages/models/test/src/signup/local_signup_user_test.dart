import 'package:models/src/signup/local_signup_user.dart';
import 'package:test/test.dart';

void main() {
  group('LocalSignupUser', () {
    test('can be istantiated', () {
      expect(const LocalSignupUser(username: 'bob'), isNotNull);
    });

    group('with LocalSignupUser istantiated', () {
      late LocalSignupUser localSignupUser;
      setUp(() {
        localSignupUser = const LocalSignupUser(username: 'bob');
      });
      test('can copyWith', () {
        localSignupUser.copyWith();
      });

      test('can get isEmpty', () {
        expect(localSignupUser.isEmpty, false);
        expect(localSignupUser.isNotEmpty, true);
      });
    });
  });
}

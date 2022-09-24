import 'package:models/src/signup/signup_flow_state.dart';
import 'package:test/test.dart';

void main() {
  group('SignupFlowState', () {
    test('can be istantiated', () {
      expect(const SignupFlowState(), isNotNull);
    });

    group('with SignupFlowState istantiated', () {
      late SignupFlowState signupFlowState;
      setUp(() {
        signupFlowState = const SignupFlowState();
      });
      test('can copyWith', () {
        signupFlowState.copyWith();
      });
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/login/bloc/credential_status.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockAuthenticationRepository extends Mock implements UserRepository {}

void main() {
  final authenticationRepository = MockAuthenticationRepository();
  group('signal credential cubit tests', () {
    setUp(() {
      when(() => authenticationRepository.isUsernameAvailable('notexisting'))
          .thenAnswer((_) => Future.value(true));

      when(() => authenticationRepository.isUsernameAvailable('existing'))
          .thenAnswer((_) => Future.value(false));
    });

    test('Initial state should be SignupCredentialState', () {
      final cubit = SignupCredentialCubit(
        authenticationRepository: authenticationRepository,
      );

      expect(cubit.state, const SignupCredentialState());
    });

    test('username state should be valid if username is regex compliant',
        () async {
      final cubit = SignupCredentialCubit(
        authenticationRepository: authenticationRepository,
      );
      await cubit.usernameChanged('notexisting');
      expect(cubit.state.username.valid, true);
    });

    blocTest<SignupCredentialCubit, SignupCredentialState>(
      'passwordChanged should change password value correctly',
      build: () => SignupCredentialCubit(
        authenticationRepository: authenticationRepository,
      ),
      act: (cubit) => cubit.passwordChanged('new'),
      verify: (cubit) {
        expect(cubit.state.password.value, 'new');
      },
    );

    group('signUp flow', () {
      var signUpFlow = FlowController<SignupFlowState>(
        const SignupFlowState(),
      );
      blocTest<SignupCredentialCubit, SignupCredentialState>(
        '''submit should change signup status to selecting location 
        if credentials are valid''',
        seed: () => const SignupCredentialState(
          username: Username.pure(value: 'notexisting'),
          password: Password.pure(value: 'password123'),
        ),
        build: () => SignupCredentialCubit(
          authenticationRepository: authenticationRepository,
        ),
        act: (cubit) => cubit.submitted(
          signUpFlow = FlowController<SignupFlowState>(
            const SignupFlowState(),
          ),
        ),
        verify: (cubit) {
          expect(signUpFlow.state.signupStatus, SignupStatus.selectingLocation);
        },
      );

      blocTest<SignupCredentialCubit, SignupCredentialState>(
        '''submit should change signup status to failed  
        if credentials are invalid''',
        seed: () => const SignupCredentialState(
          username: Username.pure(value: 'existing'),
          password: Password.pure(value: 'password123'),
        ),
        build: () => SignupCredentialCubit(
          authenticationRepository: authenticationRepository,
        ),
        act: (cubit) => cubit.submitted(
          signUpFlow = FlowController<SignupFlowState>(
            const SignupFlowState(),
          ),
        ),
        verify: (cubit) {
          expect(cubit.state.status, CredentialStatus.failed);
        },
      );
    });
  });
}

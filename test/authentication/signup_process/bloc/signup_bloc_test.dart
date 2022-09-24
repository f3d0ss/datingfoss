// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/bloc/signup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements LocalUser {}

void main() {
  group('SignupBloc', () {
    late UserRepository authenticationRepository;
    late LocalSignupUser signupUser;

    setUp(() {
      signupUser = LocalSignupUser(username: '');
      authenticationRepository = MockAuthenticationRepository();
    });

    test('initial state is empty SignupState', () {
      expect(
        SignupBloc(authenticationRepository: authenticationRepository).state,
        SignupState(),
      );
    });
    group('SignupRequested', () {
      blocTest<SignupBloc, SignupState>(
        'emits authenticated when user is not empty',
        setUp: () {
          when(() => authenticationRepository.signUp(signupUser: signupUser))
              .thenAnswer((_) async {});
        },
        build: () => SignupBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) => bloc.add(SignupRequested(user: signupUser)),
        expect: () => [
          const SignupState(signupBlocState: SignupBlocState.loading),
          const SignupState(signupBlocState: SignupBlocState.signedUp)
        ],
      );
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/login/bloc/credential_status.dart';
import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repositories/repositories.dart';

class MockAuthenticationRepository extends Mock implements UserRepository {}

void main() {
  group('login', () {
    late MockAuthenticationRepository authenticationRepository;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    test('Credentials should be empty on start', () {
      final loginBloc =
          LoginBloc(authenticationRepository: authenticationRepository);

      final state = loginBloc.state;
      expect(state.status, CredentialStatus.editing);
      expect(state.username.value, '');
      expect(state.password.value, '');
    });

    blocTest<LoginBloc, LoginState>(
      'username status should be valid if entering an existing username',
      setUp: () {
        when(() => authenticationRepository.doesUserExist('existing'))
            .thenAnswer((_) => Future.value(true));
      },
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const UsernameChanged('existing')),
      verify: (bloc) {
        expect(bloc.state.username.valid, true);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'username status should be invalid if entering a not existing username',
      setUp: () {
        when(() => authenticationRepository.doesUserExist('notexisting'))
            .thenAnswer((_) => Future.value(false));
      },
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const UsernameChanged('notexisting')),
      verify: (bloc) {
        expect(bloc.state.username.valid, false);
      },
    );

    blocTest<LoginBloc, LoginState>(
      '''password status should be valid if entering a password matched by 
      password regex''',
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const PasswordChanged('password123')),
      verify: (bloc) {
        expect(bloc.state.password.valid, true);
      },
    );

    blocTest<LoginBloc, LoginState>(
      '''password status should be invalid if entering a password not matched 
      by password regex''',
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const PasswordChanged('a')),
      verify: (bloc) {
        expect(bloc.state.password.valid, false);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'Login should succeed if authentication succeeds',
      seed: () => const LoginState(
        username: Username.pure(value: 'existing'),
        password: Password.pure(value: 'password123'),
      ),
      setUp: () {
        when(
          () => authenticationRepository.logInWithUsernameAndPassword(
            username: 'existing',
            password: 'password123',
          ),
        ).thenAnswer(
          (_) => Future<void>.value(),
        );
      },
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) {
        bloc.add(Submitted());
      },
      verify: (bloc) {
        expect(bloc.state.status != CredentialStatus.failed, true);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'Login should fail if authentication fails',
      seed: () => const LoginState(
        username: Username.pure(value: 'notexisting'),
        password: Password.pure(value: 'password123'),
      ),
      setUp: () {
        when(
          () => authenticationRepository.logInWithUsernameAndPassword(
            username: 'existing',
            password: 'password123',
          ),
        ).thenThrow(Exception());
      },
      build: () =>
          LoginBloc(authenticationRepository: authenticationRepository),
      act: (bloc) {
        bloc.add(Submitted());
      },
      verify: (bloc) {
        expect(bloc.state.status == CredentialStatus.failed, true);
      },
    );
  });
}

// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../../helpers/hydrated_bloc.dart';

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements LocalUser {}

void main() {
  group('AppBloc', () {
    late UserRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
      when(
        () => authenticationRepository.currentUser,
      ).thenReturn(LocalUser.empty);
    });

    test('initial state is unauthenticated when user is empty', () {
      expect(
        AppBloc(authenticationRepository: authenticationRepository).state,
        AppState.unauthenticated(),
      );
    });
    group('UserChanged', () {
      final user = MockUser();
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not empty',
        setUp: () {
          when(() => user.username).thenReturn('username');
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
        },
        build: () => AppBloc(
          authenticationRepository: authenticationRepository,
        ),
        seed: AppState.unauthenticated,
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is empty',
        setUp: () {
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(LocalUser.empty),
          );
        },
        build: () => AppBloc(
          authenticationRepository: authenticationRepository,
        ),
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      mockHydratedStorage();
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        setUp: () {
          when(() => authenticationRepository.logOut()).thenAnswer(
            (_) async {},
          );
        },
        build: () {
          return AppBloc(
            authenticationRepository: authenticationRepository,
          );
        },
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenticationRepository.logOut()).called(1);
        },
      );
    });
  });
}

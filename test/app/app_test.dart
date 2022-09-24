import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/app.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/authentication/login/login.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/main_navigation/bloc/main_navigation_bloc.dart';
import 'package:datingfoss/main_navigation/main_screen.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockUser extends Mock implements LocalUser {}

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

class MockDiscoverBloc extends MockBloc<DiscoverEvent, DiscoverState>
    implements DiscoverBloc {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockMainNavigationBloc
    extends MockBloc<MainNavigationEvent, MainNavigationState>
    implements MainNavigationBloc {}

class MockMatchBloc extends MockBloc<MatchEvent, MatchState>
    implements MatchBloc {}

void main() {
  late AppBloc appBloc;
  late DiscoverBloc discoverBloc;
  late LoginBloc loginBloc;
  late MainNavigationBloc mainBloc;
  late ChatBloc chatBloc;
  late MatchBloc matchBloc;
  setUpAll(() {
    appBloc = MockAppBloc();
    discoverBloc = MockDiscoverBloc();
    loginBloc = MockLoginBloc();
    mainBloc = MockMainNavigationBloc();
    chatBloc = MockChatBloc();
    matchBloc = MockMatchBloc();
    GetIt.instance
      ..registerFactory<AppBloc>(() => appBloc)
      ..registerFactory<DiscoverBloc>(() => discoverBloc)
      ..registerFactory<LoginBloc>(() => loginBloc)
      ..registerFactory<MainNavigationBloc>(() => mainBloc)
      ..registerFactory<MatchBloc>(() => matchBloc)
      ..registerFactory<ChatBloc>(() => chatBloc);
  });
  group('App', () {
    late UserRepository authenticationRepository;
    late LocalUser user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();

      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.isNotEmpty).thenReturn(true);
      when(() => user.isEmpty).thenReturn(false);
      when(() => user.username).thenReturn('BeautifulUsername');
      when(() => discoverBloc.state).thenReturn(const DiscoverState());
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      when(() => mainBloc.state).thenReturn(const MainNavigationState());
      when(() => matchBloc.state).thenReturn(const MatchState());
      when(() => chatBloc.state).thenReturn(
        ChatState(chats: LinkedHashMap<String, Chat>(), messageText: ''),
      );
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        const App(),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late UserRepository authenticationRepository;
    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => chatBloc.state).thenReturn(
        ChatState(chats: LinkedHashMap<String, Chat>(), messageText: ''),
      );
      when(() => loginBloc.state).thenReturn(const LoginState());
      when(() => discoverBloc.state).thenReturn(const DiscoverState());
      when(() => mainBloc.state).thenReturn(const MainNavigationState());
    });

    testWidgets('navigates to LoginScreen when unauthenticated',
        (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const App()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('navigates to MainScreen when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.username).thenReturn('BeautifulUsername');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(MainScreen), findsOneWidget);
    });
  });

  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [
          isA<MaterialPage<void>>()
              .having((p) => p.child, 'child', isA<MainScreen>())
        ],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [
          isA<MaterialPage<void>>()
              .having((p) => p.child, 'child', isA<LoginScreen>())
        ],
      );
    });
  });
}

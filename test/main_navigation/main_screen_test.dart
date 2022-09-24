import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/main_navigation/bloc/main_navigation_bloc.dart';
import 'package:datingfoss/main_navigation/main_screen.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart' as model;
import 'package:repositories/repositories.dart';

class MockUser extends Mock implements model.LocalUser {}

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

class MockDiscoverBloc extends MockBloc<DiscoverEvent, DiscoverState>
    implements DiscoverBloc {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockMainBloc extends MockBloc<MainNavigationEvent, MainNavigationState>
    implements MainNavigationBloc {}

class MockMatchBloc extends MockBloc<MatchEvent, MatchState>
    implements MatchBloc {}

void main() {
  late AppBloc appBloc;
  late DiscoverBloc discoverBloc;
  late LoginBloc loginBloc;
  late ChatBloc chatBloc;
  late MatchBloc matchBloc;
  late MainNavigationBloc mainBloc;
  setUpAll(() {
    appBloc = MockAppBloc();
    discoverBloc = MockDiscoverBloc();
    loginBloc = MockLoginBloc();
    mainBloc = MainNavigationBloc();
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
  group('MainScreen', () {
    late UserRepository authenticationRepository;
    late model.LocalUser user;

    setUp(() {
      mainBloc = MockMainBloc();
      when(() => mainBloc.state).thenReturn(const MainNavigationState());
      authenticationRepository = MockAuthenticationRepository();
      user = const model.LocalUser(
        username: 'username',
        publicInfo:
            model.PublicInfo(sex: 0.5, searching: model.RangeValues(0, 0.5)),
        privateInfo: model.PrivateInfo.empty,
      );

      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => discoverBloc.state).thenReturn(const DiscoverState());
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      when(() => matchBloc.state).thenReturn(const MatchState());
      when(() => chatBloc.state).thenReturn(
        ChatState(
          messageText: '',
          chats: LinkedHashMap<String, model.Chat>(),
        ),
      );
    });

    testWidgets('emit state with PageChangedToExplore when discover tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const MainScreen(),
          ),
        ),
      );
      await tester.pump();
      final discoverNavButton = find.byIcon(Icons.explore);
      await tester.tap(discoverNavButton);
      verify(() => mainBloc.add(PageChangedToExplore())).called(1);
    });
    testWidgets('emit state with PageChangedToChat when chat tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const MainScreen(),
          ),
        ),
      );
      await tester.pump();
      final chatNavButton = find.byIcon(Icons.chat);
      await tester.tap(chatNavButton);
      verify(() => mainBloc.add(PageChangedToChat())).called(1);
    });

    testWidgets('emit state with PageChangedToProfile when profile tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const MainScreen(),
          ),
        ),
      );
      await tester.pump();
      final profileNavButton = find.byIcon(Icons.person);
      await tester.tap(profileNavButton);
      verify(() => mainBloc.add(PageChangedToProfile())).called(1);
    });

    testWidgets('change main page when state change mainPage', (tester) async {
      whenListen(
        mainBloc,
        Stream.fromIterable(const [
          MainNavigationState(),
          MainNavigationState(mainPage: MainPage.chat),
          MainNavigationState(mainPage: MainPage.profile)
        ]),
      );

      tester.binding.window.physicalSizeTestValue = const Size(800, 1000);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const MainScreen(),
          ),
        ),
      );
      await tester.pump();
      final profileNavButton = find.byIcon(Icons.person);
      await tester.tap(profileNavButton);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // resets the screen to its original size after the test end
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });
  });
}

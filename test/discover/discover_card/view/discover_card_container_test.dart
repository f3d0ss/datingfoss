import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:datingfoss/discover/discover_card/view/card_overlay.dart';
import 'package:datingfoss/discover/discover_card/view/discover_card_background.dart';
import 'package:datingfoss/discover/discover_card/view/discover_card_container.dart';
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

class MockDiscoverCardBloc
    extends MockBloc<DiscoverCardEvent, DiscoverCardState>
    implements DiscoverCardBloc {}

void main() {
  late AppBloc appBloc;
  late DiscoverCardBloc discoverCardBloc;
  late Partner partner;
  setUpAll(() {
    appBloc = MockAppBloc();
    discoverCardBloc = MockDiscoverCardBloc();
    partner = const Partner(
      username: 'username',
      publicInfo: PublicInfo(
        interests: ['bob', 'vagana'],
        pictures: ['imageId', 'imagePD'],
      ),
      jsonPublicKey: {},
    );
    // chatBloc = MockChatBloc();
    GetIt.instance
      ..registerFactoryParam((param1, param2) => discoverCardBloc)
      ..registerFactory<AppBloc>(() => appBloc);
  });
  group('DiscoverCardContainer', () {
    late UserRepository authenticationRepository;
    late LocalUser user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();

      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.username).thenReturn('BeautifulUsername');
      when(() => discoverCardBloc.state).thenReturn(
        DiscoverCardState(
          partner: partner,
          index: 0,
          distance: 12,
          pictures: {'imageId': File('test_resources/pic1.jpg')},
        ),
      );
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    late DiscoverCardState discoverCardState;

    testWidgets('renders Card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: DiscoverCardContainer(partner: partner, landscape: false),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(DiscoverCardBackground), findsOneWidget);
      expect(find.byType(CardOverlay), findsOneWidget);
    });

    group('with index = 1', () {
      setUp(() {
        discoverCardState = DiscoverCardState(
          partner: partner,
          index: 1,
          distance: 12,
          pictures: {
            'imageId': File('test_resources/pic1.jpg'),
            'imageId2': File('test_resources/pic1.jpg')
          },
        );
        when(() => discoverCardBloc.state).thenReturn(discoverCardState);
        when(() => user.interests).thenReturn([const PrivateData('bob')]);
      });
      testWidgets('renders Card with interests', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider.value(
              value: appBloc,
              child: DiscoverCardContainer(partner: partner, landscape: false),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(DiscoverCardBackground), findsOneWidget);
        expect(find.byType(CardOverlay), findsOneWidget);
      });
    });
  });
}

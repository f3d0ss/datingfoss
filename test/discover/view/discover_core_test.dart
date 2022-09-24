import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:datingfoss/discover/view/discover_core.dart';
import 'package:datingfoss/discover/view/discover_swipe_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:tcard/tcard.dart';

class MockDiscoverBloc extends MockBloc<DiscoverEvent, DiscoverState>
    implements DiscoverBloc {}

class MockDiscoverCardBloc
    extends MockBloc<DiscoverCardEvent, DiscoverCardState>
    implements DiscoverCardBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockUser extends Mock implements LocalUser {}

class MockPartner extends Mock implements Partner {}

class MockPublicInfo extends Mock implements PublicInfo {}

void main() {
  late DiscoverBloc discoverBloc;
  late DiscoverCardBloc discoverCardBloc;
  late LocalUser authUser;
  late AppBloc appBloc;
  late Partner partner;
  late PublicInfo partnerPublicInfo;
  setUpAll(() {
    final GetIt getIt;
    getIt = GetIt.instance;
    appBloc = MockAppBloc();
    discoverBloc = MockDiscoverBloc();
    discoverCardBloc = MockDiscoverCardBloc();
    getIt.registerFactory<DiscoverBloc>(() => discoverBloc);
    authUser = MockUser();
    partner = MockPartner();
    partnerPublicInfo = MockPublicInfo();
    getIt.registerFactoryParam<DiscoverCardBloc, Partner, LocalUser>(
      (partner, authUser) => discoverCardBloc,
    );
    when(() => appBloc.state).thenReturn(
      AppState.authenticated(authUser),
    );
    when(() => authUser.username).thenReturn('pippo');
    when(() => discoverCardBloc.state).thenReturn(
      DiscoverCardState(
        partner: partner,
        index: 0,
        distance: null,
      ),
    );
    when(() => partner.username).thenReturn('pippo');
    when(() => partner.hasPrivateInfo).thenReturn(false);
    when(() => partner.publicInfo).thenReturn(partnerPublicInfo);
    when(() => partnerPublicInfo.pictures).thenReturn(['0', '1']);
    when(() => partnerPublicInfo.bio).thenReturn('');
    when(() => partnerPublicInfo.interests).thenReturn([]);
    when(() => partnerPublicInfo.textInfo).thenReturn({});
  });
  group('DiscoverCore', () {
    setUp(() {
      when(() => authUser.username).thenReturn('pino');
      when(() => discoverBloc.state).thenReturn(const DiscoverState());
    });

    testWidgets('renders loading screen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => appBloc,
              ),
              BlocProvider(
                create: (context) => discoverBloc,
              ),
            ],
            child: const DiscoverCore(landscape: false),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TCardWithButtonsContainer), findsOneWidget);
      expect(find.byType(ScreenTitle), findsOneWidget);
    });

    // BROKEN
    testWidgets('renders TCard', (tester) async {
      when(() => discoverBloc.state).thenReturn(
        DiscoverState(
          partners: [partner],
          status: DiscoverStatus.standard,
          swipeInfoList: const [
            DiscoverSwipeInfo(0, PartnerChoice.like),
            DiscoverSwipeInfo(1, PartnerChoice.discard)
          ],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: appBloc),
              BlocProvider.value(value: discoverBloc),
            ],
            child: const DiscoverCore(landscape: false),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TCard), findsOneWidget);
    });
  });

  group('Background', () {
    testWidgets('renders Background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(builder: (context, child) => const ScreenTitle()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScreenTitle), findsOneWidget);
    });
  });

  group('TCardWithButtonsContainer', () {
    // BROKEN
    testWidgets(
      'handle like button',
      (tester) async {
        when(() => discoverBloc.state).thenReturn(
          DiscoverState(
            partners: [partner],
            status: DiscoverStatus.standard,
          ),
        );
        whenListen(
          discoverBloc,
          Stream.fromIterable(
            [
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.standard,
              ),
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.likeing,
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: discoverBloc,
                ),
                BlocProvider.value(
                  value: appBloc,
                ),
              ],
              child: TCardWithButtonsContainer(landscape: false),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final discoverButton = find.byType(DiscoverButton);
        expect(discoverButton, findsWidgets);
        final button = find.descendant(
          of: discoverButton,
          matching: find.byType(ElevatedButton),
        );
        expect(
          tester
              .widgetList<ElevatedButton>(button)
              .every((element) => !element.enabled),
          isTrue,
        );
        verify(
          () => discoverBloc.add(
            const DiscoverSwiped(direction: SwipeDirection.Right, index: 1),
          ),
        );
      },
    );
    testWidgets(
      'handle discard button',
      (tester) async {
        when(() => discoverBloc.state).thenReturn(
          DiscoverState(
            partners: [partner],
            status: DiscoverStatus.standard,
          ),
        );
        whenListen(
          discoverBloc,
          Stream.fromIterable(
            [
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.standard,
              ),
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.discarding,
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: discoverBloc,
                ),
                BlocProvider.value(
                  value: appBloc,
                ),
              ],
              child: TCardWithButtonsContainer(landscape: false),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final discoverButton = find.byType(DiscoverButton);
        expect(discoverButton, findsWidgets);
        final button = find.descendant(
          of: discoverButton,
          matching: find.byType(ElevatedButton),
        );
        expect(
          tester
              .widgetList<ElevatedButton>(button)
              .every((element) => !element.enabled),
          isTrue,
        );
        verify(
          () => discoverBloc.add(
            const DiscoverSwiped(direction: SwipeDirection.Left, index: 1),
          ),
        );
      },
    );

    testWidgets(
      'execute onLikePressed, onBackPressed, onDiscardPressed',
      (tester) async {
        when(() => discoverBloc.state).thenReturn(
          DiscoverState(
            partners: [partner],
            status: DiscoverStatus.standard,
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: discoverBloc,
                ),
                BlocProvider.value(
                  value: appBloc,
                ),
              ],
              child: TCardWithButtonsContainer(landscape: false),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final discoverButton = find
            .byType(DiscoverSwipeButtons)
            .evaluate()
            .single
            .widget as DiscoverSwipeButtons;
        discoverButton.onBackPressed();
        verify(() => discoverBloc.add(DiscoverBackButtonPressed())).called(1);
        discoverButton.onLikePressed();
        verify(() => discoverBloc.add(DiscoverLikeButtonPressed())).called(1);
        discoverButton.onDiscardPressed();
        verify(() => discoverBloc.add(DiscoverDiscardButtonPressed()))
            .called(1);
      },
    );

    testWidgets(
      'handle back status',
      (tester) async {
        when(() => discoverBloc.state).thenReturn(
          DiscoverState(
            partners: [partner],
            status: DiscoverStatus.standard,
          ),
        );
        whenListen(
          discoverBloc,
          Stream.fromIterable(
            [
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.standard,
              ),
              DiscoverState(
                partners: [partner],
                status: DiscoverStatus.backing,
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: discoverBloc,
                ),
                BlocProvider.value(
                  value: appBloc,
                ),
              ],
              child: TCardWithButtonsContainer(landscape: false),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final discoverButton = find.byType(DiscoverButton);
        expect(discoverButton, findsWidgets);
        final button = find.descendant(
          of: discoverButton,
          matching: find.byType(ElevatedButton),
        );
        expect(
          tester
              .widgetList<ElevatedButton>(button)
              .every((element) => !element.enabled),
          isTrue,
        );
      },
    );
  });
}

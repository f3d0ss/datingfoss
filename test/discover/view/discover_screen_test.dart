import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:datingfoss/discover/view/discover_background.dart';
import 'package:datingfoss/discover/view/discover_core.dart';
import 'package:datingfoss/discover/view/discover_screen.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockDiscoverBloc extends MockBloc<DiscoverEvent, DiscoverState>
    implements DiscoverBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockDiscoverCardBloc
    extends MockBloc<DiscoverCardEvent, DiscoverCardState>
    implements DiscoverCardBloc {}

class MockPartnerDetailBloc
    extends MockBloc<PartnerDetailEvent, PartnerDetailState>
    implements PartnerDetailBloc {}

class MockAppState extends Mock implements AppState {}

class MockLocalUser extends Mock implements LocalUser {}

void main() {
  late AppBloc appBloc;
  late AppState appState;
  late DiscoverBloc discoverBloc;
  late LocalUser localUser;
  late GetIt getIt;
  setUpAll(() {
    getIt = GetIt.instance;
    discoverBloc = MockDiscoverBloc();
    getIt.registerFactory<DiscoverBloc>(() => discoverBloc);
    appBloc = MockAppBloc();
    appState = MockAppState();
    localUser = MockLocalUser();
    when(() => localUser.username).thenReturn('pippo');
    when(() => appBloc.state).thenReturn(appState);
    when(() => appState.user).thenReturn(localUser);
    getIt.registerFactory<AppBloc>(() => appBloc);
  });
  group('DiscoverScreen', () {
    setUp(() {
      when(() => discoverBloc.state).thenReturn(const DiscoverState());
    });

    testWidgets('renders DiscoverBackground', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1000, 1800);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => BlocProvider(
            create: (context) => appBloc,
            child: const DiscoverScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(DiscoverBackground), findsOneWidget);
    });
    testWidgets('renders DiscoverCore', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => BlocProvider(
            create: (context) => appBloc,
            child: const DiscoverScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(DiscoverCore), findsOneWidget);
    });

    group('if landscape, with a partner in DiscoverState', () {
      late Partner partner;
      late PartnerDetailBloc partnerDetailBloc;
      late DiscoverCardBloc discoverCardBloc;

      setUp(() {
        partnerDetailBloc = MockPartnerDetailBloc();
        discoverCardBloc = MockDiscoverCardBloc();
        getIt.registerFactory(() => partnerDetailBloc);
        partner = const Partner(
          username: 'username',
          publicInfo: PublicInfo.empty,
          jsonPublicKey: {},
        );
        getIt.registerFactoryParam<DiscoverCardBloc, Partner, LocalUser>(
          (partner, authUser) => discoverCardBloc,
        );
        when(() => discoverBloc.state).thenReturn(
          DiscoverState(
            status: DiscoverStatus.standard,
            partners: [partner],
          ),
        );
        when(() => partnerDetailBloc.state).thenReturn(
          PartnerDetailState(username: partner.username),
        );
        when(() => discoverCardBloc.state).thenReturn(
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
          ),
        );
        when(() => localUser.interests).thenReturn([]);
      });
      testWidgets('renders PartnerDetailPage', (tester) async {
        tester.binding.window.physicalSizeTestValue = const Size(3000, 2000);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => BlocProvider(
              create: (context) => appBloc,
              child: const DiscoverScreen(),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(PartnerDetailPage), findsOneWidget);
      });
    });
  });
}

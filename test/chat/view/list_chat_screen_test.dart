import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/chat/view/list_chat_screen.dart';
import 'package:datingfoss/chat/view/single_chat_screen.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

class MockMatchBloc extends Mock implements MatchBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockPartnerDetailBloc
    extends MockBloc<PartnerDetailEvent, PartnerDetailState>
    implements PartnerDetailBloc {}

void main() {
  late ChatBloc chatBloc;
  late MatchBloc matchBloc;
  late String partnerUsername;
  late Partner partner;
  setUpAll(() {
    chatBloc = MockChatBloc();
    matchBloc = MockMatchBloc();
    partnerUsername = 'bob';
    partner = Partner(
      username: partnerUsername,
      publicInfo: PublicInfo.empty,
      jsonPublicKey: const {},
    );
  });
  group('ListChatScreen', () {
    setUp(() {
      when(() => chatBloc.state).thenReturn(
        ChatState(
          messageText: '',
          chats: LinkedHashMap.from({
            partnerUsername: Chat(partner: partner, messages: ListQueue()),
          }),
        ),
      );
      when(() => matchBloc.state).thenReturn(
        MatchState(partnerThatLikeMe: {partnerUsername: const []}),
      );

      whenListen(
        chatBloc,
        Stream.value(
          ChatState(
            messageText: '',
            chats: LinkedHashMap.from({
              partnerUsername: Chat(
                partner: partner,
                messages: ListQueue()
                  ..add(
                    Message(
                      content: 'content',
                      from: partnerUsername,
                      isRead: false,
                      timestamp: DateTime.utc(0),
                    ),
                  ),
              ),
            }),
          ),
        ),
      );
      whenListen(
        matchBloc,
        Stream.value(
          MatchState(partnerThatLikeMe: {partnerUsername: const []}),
        ),
      );
    });

    testWidgets('renders ListView', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1000, 1800);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: chatBloc),
              BlocProvider.value(value: matchBloc),
            ],
            child: const ListChatScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);
    });

    group('when bloc emit selectedChat', () {
      late LinkedHashMap<String, Chat> chats;
      late AppBloc appBloc;
      late LocalUser localUser;

      setUpAll(() {
        registerFallbackValue(
          MaterialPageRoute<dynamic>(builder: (_) => Container()),
        );
      });

      setUp(() {
        appBloc = MockAppBloc();
        localUser = const LocalUser(
          username: 'username',
          publicInfo: PublicInfo.empty,
          privateInfo: PrivateInfo.empty,
        );
        chats = LinkedHashMap.from({
          partnerUsername: Chat(partner: partner, messages: ListQueue()),
        });
        when(() => chatBloc.state).thenReturn(
          ChatState(messageText: '', chats: chats),
        );
        whenListen(
          chatBloc,
          Stream.fromIterable([
            ChatState(messageText: '', chats: chats),
            ChatState(
              messageText: '',
              chats: chats,
              selectedChat: partner.username,
            ),
          ]),
        );
        when(() => appBloc.state).thenReturn(AppState.authenticated(localUser));
        whenListen(appBloc, Stream.value(AppState.authenticated(localUser)));
      });
      group('if landscape', () {
        testWidgets('navigate to SingleChatScreen', (tester) async {
          tester.binding.window.physicalSizeTestValue = const Size(2000, 1500);
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

          await tester.pumpWidget(
            BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: chatBloc),
                    BlocProvider.value(value: matchBloc),
                  ],
                  child: const ListChatScreen(),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(SingleChatScreen), findsOneWidget);
        });
      });
      group('if portrait', () {
        testWidgets('navigate to SingleChatScreen', (tester) async {
          tester.binding.window.physicalSizeTestValue = const Size(1500, 2000);
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
          final mockObserver = MockNavigatorObserver();
          await tester.pumpWidget(
            BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: chatBloc),
                    BlocProvider.value(value: matchBloc),
                  ],
                  child: const ListChatScreen(),
                ),
                navigatorObservers: [mockObserver],
              ),
            ),
          );

          await tester.pumpAndSettle();

          verify(() => mockObserver.didPush(any(), any()));

          expect(find.byType(SingleChatScreen), findsOneWidget);
        });
      });
    });

    group('when bloc emit partnerDetailScreen', () {
      late LinkedHashMap<String, Chat> chats;
      late AppBloc appBloc;
      late LocalUser localUser;
      late PartnerDetailBloc partnerDetailBloc;

      setUpAll(() {
        registerFallbackValue(
          MaterialPageRoute<dynamic>(builder: (_) => Container()),
        );
        partnerDetailBloc = MockPartnerDetailBloc();
        GetIt.I.registerFactoryParam((param1, param2) => partnerDetailBloc);
      });

      setUp(() {
        appBloc = MockAppBloc();
        localUser = const LocalUser(
          username: 'username',
          publicInfo: PublicInfo.empty,
          privateInfo: PrivateInfo.empty,
        );
        chats = LinkedHashMap.from({
          partnerUsername: Chat(partner: partner, messages: ListQueue()),
        });
        when(() => chatBloc.state).thenReturn(
          ChatState(
            messageText: '',
            chats: chats,
            selectedChat: partner.username,
            partnerDetailScreen: true,
          ),
        );
        whenListen(
          chatBloc,
          Stream.fromIterable([
            ChatState(
              messageText: '',
              chats: chats,
              selectedChat: partner.username,
            ),
            ChatState(
              messageText: '',
              chats: chats,
              selectedChat: partner.username,
              partnerDetailScreen: true,
            ),
          ]),
        );
        when(() => appBloc.state).thenReturn(AppState.authenticated(localUser));
        whenListen(appBloc, Stream.value(AppState.authenticated(localUser)));
        when(() => partnerDetailBloc.state)
            .thenReturn(PartnerDetailState(username: partnerUsername));
        whenListen(
          partnerDetailBloc,
          Stream.value(PartnerDetailState(username: partnerUsername)),
        );
        when(() => partnerDetailBloc.close()).thenAnswer((_) async {});
      });
      group('if landscape', () {
        testWidgets('open Detail page', (tester) async {
          tester.binding.window.physicalSizeTestValue = const Size(2000, 1500);
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
          await tester.pumpWidget(
            BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: chatBloc),
                    BlocProvider.value(value: matchBloc),
                  ],
                  child: const ListChatScreen(),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(PartnerDetailPage), findsOneWidget);
        });
      });
      group('if portrait', () {
        testWidgets('navigate to Detail page', (tester) async {
          tester.binding.window.physicalSizeTestValue = const Size(1500, 2000);
          addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
          final mockObserver = MockNavigatorObserver();
          await tester.pumpWidget(
            BlocProvider.value(
              value: appBloc,
              child: MaterialApp(
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: chatBloc),
                    BlocProvider.value(value: matchBloc),
                  ],
                  child: const ListChatScreen(),
                ),
                navigatorObservers: [mockObserver],
              ),
            ),
          );

          await tester.pumpAndSettle();

          verify(() => mockObserver.didPush(any(), any()));

          expect(find.byType(PartnerDetailPage), findsOneWidget);
        });
      });
    });
  });
}

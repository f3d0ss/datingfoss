import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/chat/view/single_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockChatBloc extends MockBloc<ChatEvent, ChatState> implements ChatBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late ChatBloc chatBloc;
  late AppBloc appBloc;

  late String partnerUsername;
  late Partner partner;
  late LocalUser localUser;
  setUpAll(() {
    chatBloc = MockChatBloc();
    appBloc = MockAppBloc();
    partnerUsername = 'bob';
    partner = Partner(
      username: partnerUsername,
      publicInfo: PublicInfo.empty,
      jsonPublicKey: const {},
    );
    localUser = const LocalUser(
      username: 'username',
      publicInfo: PublicInfo.empty,
      privateInfo: PrivateInfo.empty,
    );
  });
  group('SingleChatScreen', () {
    setUp(() {
      when(() => chatBloc.state).thenReturn(
        ChatState(
          messageText: '',
          chats: LinkedHashMap.from({
            partnerUsername: Chat(partner: partner, messages: ListQueue()),
          }),
        ),
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

      when(() => appBloc.state).thenReturn(AppState.authenticated(localUser));
      whenListen(appBloc, Stream.value(AppState.authenticated(localUser)));
    });

    testWidgets('renders ListView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SingleChatScreen(
            partnerUsername: partnerUsername,
            bloc: chatBloc,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('on tap send add SendMessageRequested evento to bloc',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SingleChatScreen(
            partnerUsername: partnerUsername,
            bloc: chatBloc,
          ),
        ),
      );
      await tester.pump();
      final sendButton = find.byType(ElevatedButton);
      await tester.tap(sendButton);
      verify(
        () => chatBloc.add(SendMessageRequested(to: partnerUsername)),
      ).called(1);
    });

    testWidgets(
      'on tap detail add PartnerDetailSelected event',
      (tester) async {
        await tester.pumpWidget(
          BlocProvider.value(
            value: appBloc,
            child: MaterialApp(
              home: SingleChatScreen(
                partnerUsername: partnerUsername,
                bloc: chatBloc,
              ),
            ),
          ),
        );
        await tester.pump();
        final detailButton = find.byIcon(Icons.remove_red_eye_outlined);
        await tester.tap(detailButton);
        await tester.pump();
        verify(
          () => chatBloc.add(const PartnerDetailSelected()),
        ).called(1);
      },
    );
  });
}

import 'dart:async';
import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/match/view/match_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockMatchBloc extends Mock implements MatchBloc {}

class MockChatBloc extends Mock implements ChatBloc {}

void main() {
  late ChatBloc chatBloc;
  late MatchBloc matchBloc;
  setUpAll(() {
    chatBloc = MockChatBloc();
    matchBloc = MockMatchBloc();
    // GetIt.instance.registerFactory<ChatBloc>(() => chatBloc);
  });
  group('MatchWidget', () {
    setUp(() {
      when(() => matchBloc.state).thenReturn(const MatchState());
      when(() => chatBloc.state)
          .thenReturn(ChatState(messageText: '', chats: LinkedHashMap()));
      whenListen(
        matchBloc,
        Stream.value(const MatchState()),
      );
      whenListen(
        chatBloc,
        Stream.value(ChatState(messageText: '', chats: LinkedHashMap())),
      );
    });

    testWidgets('render an empty Container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: matchBloc,
            child: const MatchWidget(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Container), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Container),
          matching: find.byType(Container),
        ),
        findsNothing,
      );
    });

    group('when match happend', () {
      late String partnerUsername;
      late List<String> partnerKeys;
      setUp(() {
        partnerUsername = 'bob';
        partnerKeys = ['key1'];
        when(() => matchBloc.state).thenReturn(const MatchState());
        whenListen(
          matchBloc,
          Stream.fromIterable([
            const MatchState(),
            MatchState(
              newMatch:
                  AddLikeMessage(username: partnerUsername, keys: partnerKeys),
            )
          ]),
        );
      });

      testWidgets('render the newMatch animation', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: matchBloc,
                ),
                BlocProvider.value(
                  value: chatBloc,
                ),
              ],
              child: const MatchWidget(),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 5));
        expect(find.byType(NewMatchAnimation), findsOneWidget);
      });
    });

    group('when undo match happend', () {
      late String partnerUsername;
      setUp(() {
        partnerUsername = 'bob';
        when(() => matchBloc.state).thenReturn(const MatchState());
        whenListen(
          matchBloc,
          Stream.fromIterable([
            const MatchState(),
            MatchState(
              undoMatch: partnerUsername,
            )
          ]),
        );
      });

      testWidgets('add MatchRemoved event to chat bloc', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: matchBloc,
                ),
                BlocProvider.value(
                  value: chatBloc,
                ),
              ],
              child: const MatchWidget(),
            ),
          ),
        );
        await tester.pump();
        verify(() => chatBloc.add(MatchRemoved(username: partnerUsername)))
            .called(1);
      });
    });
  });
}

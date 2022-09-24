import 'dart:collection';
import 'dart:convert';

import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('ChatState', () {
    const partnerUsername = 'partnerUsername';
    const partner = Partner(
      username: partnerUsername,
      publicInfo: PublicInfo.empty,
      jsonPublicKey: {},
    );
    test('can converto to and from json', () {
      final chats = LinkedHashMap<String, Chat>.from({
        partnerUsername: Chat(partner: partner, messages: ListQueue()),
      });
      final state = ChatState(chats: chats, messageText: '');
      final jsonEncodedState = jsonEncode(state);
      expect(
        state,
        ChatState.fromJson(
          jsonDecode(jsonEncodedState) as Map<String, dynamic>,
        ),
      );
    });
  });
}

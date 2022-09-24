// ignore_for_file: prefer_const_constructors
import 'dart:collection';
import 'dart:convert';

import 'package:models/src/chat_user.dart';
import 'package:models/src/message.dart';
import 'package:models/src/partner.dart';
import 'package:test/test.dart';

void main() {
  group('Chat', () {
    late Chat chat;
    late Partner partner;

    setUp(() {
      partner = Partner.empty;
      chat = Chat(partner: partner, messages: ListQueue<Message>());
    });

    test('get go to json and back', () {
      expect(chat, Chat.fromJson(encodeJson(chat.toJson())));
    });
  });
}

Map<String, dynamic> encodeJson(Map<String, dynamic> object) =>
    json.decode(json.encode(object)) as Map<String, dynamic>;

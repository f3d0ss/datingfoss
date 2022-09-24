// ignore_for_file: prefer_const_constructors

import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatEvent', () {
    const messageText = 'partnerUsername';

    test('TextMessageEdited can compare', () {
      expect(
        TextMessageEdited(messageText: messageText),
        TextMessageEdited(messageText: messageText),
      );
    });
  });
}

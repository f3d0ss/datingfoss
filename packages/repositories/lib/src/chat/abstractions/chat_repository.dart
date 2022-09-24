import 'dart:async';

import 'package:models/models.dart';

abstract class ChatRepository {
  Stream<Message> get messages;
  Future<DateTime> sendMessage({required String to, required String message});
  Future<void> dispose();
}

import 'package:controllers/src/abstractions/chat_controller.dart';

class MockChatController extends ChatController {
  @override
  Future<DateTime> sendMessage({
    required String to,
    required String content,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return DateTime.now();
  }
}

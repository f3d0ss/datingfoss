import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/src/abstractions/chat_controller.dart';

class RestChatController extends ChatController {
  RestChatController({required CommunicationHandler communicationHandler})
      : _communicationHandler = communicationHandler;

  final CommunicationHandler _communicationHandler;

  static String baseAction = 'Message';

  @override
  Future<DateTime> sendMessage({
    required String to,
    required String content,
  }) async {
    final response = await _communicationHandler.post(
      '$baseAction/Send',
      <String, dynamic>{'content': content, 'toUsername': to},
      authenticated: true,
    ) as String;
    return DateTime.parse(response);
  }
}

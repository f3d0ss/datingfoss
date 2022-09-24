import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_chat_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCommunicationHandler extends Mock implements CommunicationHandler {}

void main() {
  group('RestChatController', () {
    late CommunicationHandler communicationHandler;
    setUp(() {
      communicationHandler = MockCommunicationHandler();
    });

    test('can be instantiated', () {
      expect(
        RestChatController(
          communicationHandler: communicationHandler,
        ),
        isNotNull,
      );
    });

    group('with instantiated RestChatController', () {
      late ChatController chatController;
      late String username;
      late String content;
      late String baseAction;
      setUp(() {
        chatController = RestChatController(
          communicationHandler: communicationHandler,
        );
        username = 'alice';
        content = 'Hi';
        baseAction = RestChatController.baseAction;

        final sendMessageData = {'content': content, 'toUsername': username};
        when(
          () => communicationHandler.post(
            '$baseAction/Send',
            sendMessageData,
            authenticated: true,
          ),
        ).thenAnswer((_) async => DateTime(1990).toIso8601String());
      });

      test('can sendMessage', () {
        chatController.sendMessage(to: username, content: content);
      });
    });
  });
}

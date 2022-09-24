import 'dart:async';

import 'package:controllers/controllers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/chat/long_polling_chat_repository.dart';
import 'package:services/services.dart';
import 'package:test/test.dart';

class MockChatController extends Mock implements ChatController {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('ChatRepository', () {
    late ChatController chatController;
    late NotificationService notificationService;
    late StreamController<NotificationDTO> streamControllerNotificaitonDTO;
    setUp(() {
      chatController = MockChatController();
      notificationService = MockNotificationService();
      streamControllerNotificaitonDTO = StreamController();
      when(() => notificationService.notifications)
          .thenAnswer((_) => streamControllerNotificaitonDTO.stream);
    });
    test('can be instantiated', () {
      expect(
        LongPollingChatRepository(
          chatController: chatController,
          notificationRepository: notificationService,
        ),
        isNotNull,
      );
    });

    group('with instantiated LongPollingChatRepository', () {
      late ChatRepository chatRepository;
      late String aliceUsername;
      late String messageToAlice;

      setUp(() {
        chatRepository = LongPollingChatRepository(
          chatController: chatController,
          notificationRepository: notificationService,
        );
        aliceUsername = 'alice';
        messageToAlice = 'Hi!';
        when(
          () => chatController.sendMessage(
            to: aliceUsername,
            content: messageToAlice,
          ),
        ).thenAnswer((_) async => DateTime(1990));
      });

      test('can sendMessage', () {
        chatRepository.sendMessage(to: aliceUsername, message: messageToAlice);
      });

      test('can dispose', () {
        chatRepository.dispose();
      });

      test('can get message streams', () {
        expect(chatRepository.messages, isA<Stream<Message>>());
      });

      group('when a message arrive', () {
        late Message message;
        late MessageDTO messageDTO;
        late String messageContent;
        late DateTime messageTime;
        late NotificationDTO notificationDTO;
        const notificationMessageType = 0;
        setUp(() {
          messageTime = DateTime(1999);
          messageContent = 'Hi Alice';
          message = Message(
            content: messageContent,
            from: aliceUsername,
            timestamp: messageTime,
            isRead: false,
          );
          messageDTO = MessageDTO(
            content: messageContent,
            fromUsername: aliceUsername,
            timestamp: messageTime,
          );
          notificationDTO = NotificationDTO(
            type: notificationMessageType,
            content: messageDTO.toJson(),
          );
        });

        test('add message to the stream', () {
          chatRepository.messages.listen((event) {
            expect(event, message);
          });
          streamControllerNotificaitonDTO.add(notificationDTO);
        });
      });
    });
  });
}

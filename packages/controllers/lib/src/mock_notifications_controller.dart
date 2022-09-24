import 'package:controllers/src/abstractions/notifications_controller.dart';
import 'package:controllers/src/models/src/message_dto.dart';
import 'package:controllers/src/models/src/notification_dto.dart';

class MockNotificationsController extends NotificationsController {
  final likeMessageFromMark =
      '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';

  int counter = 0;
  @override
  Future<List<NotificationDTO>> fetch() async {
    while (true) {
      await Future<void>.delayed(const Duration(seconds: 10));
      if (counter == 0) {
        counter++;
        return [NotificationDTO(content: likeMessageFromMark, type: 1)];
      }
      return [
        NotificationDTO(
          type: 0,
          content: MessageDTO(
            content: 'Hi',
            fromUsername: 'mark88',
            timestamp: DateTime.now(),
          ).toJson(),
        )
      ];
    }
  }
}

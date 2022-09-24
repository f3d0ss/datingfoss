import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/src/abstractions/notifications_controller.dart';
import 'package:controllers/src/models/src/notification_dto.dart';

class RestNotificationsController extends NotificationsController {
  RestNotificationsController({
    required CommunicationHandler communicationHandler,
  }) : _communicationHandler = communicationHandler;
  final CommunicationHandler _communicationHandler;

  @override
  Future<List<NotificationDTO>> fetch() async {
    final notificationsJson = await _communicationHandler.get(
      'notifications/fetch',
      authenticated: true,
    ) as List;
    final notifications = notificationsJson
        .map(
          (dynamic notification) =>
              NotificationDTO.fromJson(notification as Map<String, dynamic>),
        )
        .toList();

    return notifications;
  }
}

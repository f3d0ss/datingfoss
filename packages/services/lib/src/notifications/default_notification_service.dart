import 'dart:async';

import 'package:controllers/controllers.dart';
import 'package:services/src/notifications/abstractions/notifications_service.dart';

class DefaultNotificationService extends NotificationService {
  DefaultNotificationService({
    required NotificationsController notificationsController,
  }) : _notificationsController = notificationsController;
  final NotificationsController _notificationsController;
  final StreamController<NotificationDTO> _notificationStreamController =
      StreamController<NotificationDTO>.broadcast();

  final List<NotificationDTO> _oldNotifications = [];
  var _kill = false;
  Future<void>? poolRunning;

  Future<void> _pollForNotifications() async {
    while (!_kill) {
      try {
        final notifications = await _notificationsController.fetch();
        for (final notification in notifications) {
          _oldNotifications.add(notification);
          _notificationStreamController.add(notification);
        }
      } catch (e) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  @override
  void kill() {
    _kill = true;
    _notificationStreamController.close();
  }

  @override
  Stream<NotificationDTO> get notifications async* {
    poolRunning ??= _pollForNotifications();
    for (final notification in _oldNotifications) {
      yield notification;
    }
    yield* _notificationStreamController.stream;
  }
}

import 'dart:async';

import 'package:controllers/controllers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:services/src/notifications/default_notification_service.dart';
import 'package:test/test.dart';

class MockNotificationsController extends Mock
    implements NotificationsController {}

void main() {
  group('NotificationService', () {
    late NotificationsController notificationsController;

    setUp(() {
      notificationsController = MockNotificationsController();
    });
    test('can be instantiated', () {
      expect(
        DefaultNotificationService(
          notificationsController: notificationsController,
        ),
        isNotNull,
      );
    });

    group('with instantiated DefaultNotificationService', () {
      late DefaultNotificationService notificationService;
      late NotificationDTO notificationDTO;
      setUp(() {
        notificationService = DefaultNotificationService(
          notificationsController: notificationsController,
        );
        notificationDTO = NotificationDTO(type: 0, content: 'content');

        when(() => notificationsController.fetch()).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(microseconds: 1));
          return [notificationDTO];
        });
      });
      test('can get notifications', () async {
        final stream = notificationService.notifications;
        expect(
          stream,
          isA<Stream<NotificationDTO>>(),
        );
        await expectLater(stream, emits(notificationDTO));
        notificationService.kill();
      });
    });
  });
}

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_notifications_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCommunicationHandler extends Mock implements CommunicationHandler {}

void main() {
  group('RestNotificationsController', () {
    late CommunicationHandler communicationHandler;
    setUp(() {
      communicationHandler = MockCommunicationHandler();
    });

    test('can be instantiated', () {
      expect(
        RestNotificationsController(
          communicationHandler: communicationHandler,
        ),
        isNotNull,
      );
    });

    group('with instantiated RestNotificationsController', () {
      late NotificationsController notificationController;
      late Map<String, dynamic> jsonNotificationDTO;
      setUp(() {
        notificationController = RestNotificationsController(
          communicationHandler: communicationHandler,
        );
        jsonNotificationDTO = <String, dynamic>{
          'type': 0,
          'content': 'content'
        };

        when(
          () => communicationHandler.get(
            'notifications/fetch',
            authenticated: true,
          ),
        ).thenAnswer((_) async => [jsonNotificationDTO]);
      });

      test('can fetch', () {
        notificationController.fetch();
      });
    });
  });
}

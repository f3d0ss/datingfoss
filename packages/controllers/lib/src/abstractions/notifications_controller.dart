import 'package:controllers/src/models/src/notification_dto.dart';

// ignore: one_member_abstracts
abstract class NotificationsController {
  Future<List<NotificationDTO>> fetch();
}

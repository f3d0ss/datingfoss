import 'package:controllers/controllers.dart';
import 'package:models/models.dart';

extension FromNotificationDTOTONotification on NotificationDTO {
  Notification toNotification() {
    return Notification(type: type, content: content);
  }
}

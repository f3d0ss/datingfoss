import 'package:controllers/controllers.dart';

abstract class NotificationService {
  Stream<NotificationDTO> get notifications;
  void kill();
}

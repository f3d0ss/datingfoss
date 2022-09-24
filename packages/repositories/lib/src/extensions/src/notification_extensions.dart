import 'package:models/models.dart';

extension NotificationTypeExtensions on Notification {
  bool isMessage() => type == 0;
  bool isLikeMessage() => type == 1;
}

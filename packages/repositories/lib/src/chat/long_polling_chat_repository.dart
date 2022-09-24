import 'dart:async';

import 'package:controllers/controllers.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

class LongPollingChatRepository extends ChatRepository {
  LongPollingChatRepository({
    required ChatController chatController,
    required NotificationService notificationRepository,
  })  : _chatController = chatController,
        _notificationService = notificationRepository {
    _subscription = _subscribeToMessages();
  }

  final ChatController _chatController;
  final NotificationService _notificationService;
  final StreamController<Message> _messagesStreamController =
      StreamController.broadcast(sync: true);
  late StreamSubscription<NotificationDTO> _subscription;
  @override
  Stream<Message> get messages => _messagesStreamController.stream;

  StreamSubscription<NotificationDTO> _subscribeToMessages() {
    return _notificationService.notifications.listen((notificationDTO) {
      final notification = notificationDTO.toNotification();
      if (!notification.isMessage()) return;
      final messageDTO =
          MessageDTO.fromJson(notification.content as Map<String, dynamic>);
      _messagesStreamController.add(messageDTO.toMessage());
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
  }

  @override
  Future<DateTime> sendMessage({
    required String to,
    required String message,
  }) async {
    return _chatController.sendMessage(to: to, content: message);
  }
}

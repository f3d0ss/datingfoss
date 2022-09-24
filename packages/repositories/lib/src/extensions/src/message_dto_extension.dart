import 'package:controllers/controllers.dart';
import 'package:models/models.dart';

extension FromMessageDTOToMessage on MessageDTO {
  Message toMessage() {
    return Message(
      content: content,
      from: fromUsername,
      timestamp: timestamp,
      isRead: false,
    );
  }
}

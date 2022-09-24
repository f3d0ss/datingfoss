import 'package:models/src/message.dart';
import 'package:test/test.dart';

void main() {
  group('Message', () {
    test('can go to json and back', () {
      const message = Message(from: '', content: '', isRead: false);
      expect(message, Message.fromJson(message.toJson()));
    });
  });
}

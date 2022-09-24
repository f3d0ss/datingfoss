import 'package:models/src/like_messages/like_message.dart';
import 'package:test/test.dart';

void main() {
  group('LikeMessage', () {
    test('can go to json and back', () {
      const message = LikeMessage(username: 'alice');
      expect(message, LikeMessage.fromJson(message.toJson()));
    });
  });
}

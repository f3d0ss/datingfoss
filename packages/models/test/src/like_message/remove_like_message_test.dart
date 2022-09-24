import 'package:models/src/like_messages/remove_like_message.dart';
import 'package:test/test.dart';

void main() {
  group('RemoveLikeMessage', () {
    test('can go to json and back', () {
      const message = RemoveLikeMessage(username: 'alice');
      expect(message, RemoveLikeMessage.fromJson(message.toJson()));
    });
  });
}

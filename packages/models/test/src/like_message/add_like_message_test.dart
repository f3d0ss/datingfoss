import 'package:models/src/like_messages/add_like_message.dart';
import 'package:test/test.dart';

void main() {
  group('AddLikeMessage', () {
    test('can go to json and back', () {
      const message = AddLikeMessage(username: 'alice', keys: []);
      expect(message, AddLikeMessage.fromJson(message.toJson()));
    });
  });
}

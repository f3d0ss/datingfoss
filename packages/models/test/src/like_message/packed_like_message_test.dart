import 'package:models/src/like_messages/packed_like_message.dart';
import 'package:test/test.dart';

void main() {
  group('PackedLikeMessage', () {
    test('can go to json and back', () {
      const message = PackedLikeMessage(
        type: '0',
        likeMessage: <String, dynamic>{},
        signedPartnerUsername: [],
      );
      expect(message, PackedLikeMessage.fromJson(message.toJson()));
    });
  });
}

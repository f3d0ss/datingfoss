import 'package:models/src/user/private_pic.dart';
import 'package:test/test.dart';

void main() {
  group('PrivatePic', () {
    test('can go to json and back', () {
      const message = PrivatePic(picId: 'id', keyIndex: 0);
      expect(message, PrivatePic.fromJson(message.toJson()));
    });
  });
}

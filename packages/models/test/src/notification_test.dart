import 'package:models/src/notification.dart';
import 'package:test/test.dart';

void main() {
  group('Notification', () {
    test('can be istantiated', () {
      expect(Notification(type: 0, content: ''), isNotNull);
    });
  });
}

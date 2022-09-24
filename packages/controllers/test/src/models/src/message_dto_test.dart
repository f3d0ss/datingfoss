// ignore_for_file: prefer_const_constructors

import 'package:controllers/controllers.dart';
import 'package:test/test.dart';

void main() {
  group('MessageDTO', () {
    late MessageDTO messageDTO;
    setUp(() {
      messageDTO = MessageDTO(
        content: 'content',
        fromUsername: 'from',
        timestamp: DateTime(1990),
      );
    });
    test('can toJson and fromJson', () {
      final messageDTOJsoned = MessageDTO.fromJson(messageDTO.toJson());
      expect(messageDTOJsoned.content, messageDTO.content);
      expect(messageDTOJsoned.fromUsername, messageDTO.fromUsername);
      expect(messageDTOJsoned.timestamp, messageDTO.timestamp);
    });
  });
}

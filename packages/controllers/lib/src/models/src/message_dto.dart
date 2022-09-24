import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class MessageDTO {
  MessageDTO({
    required this.content,
    required this.fromUsername,
    required this.timestamp,
  });

  factory MessageDTO.fromJson(Map<String, dynamic> json) => MessageDTO(
        content: json['content'] as String,
        fromUsername: json['fromUsername'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  final String content;
  final String fromUsername;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => _$MessageDTOToJson(this);
}

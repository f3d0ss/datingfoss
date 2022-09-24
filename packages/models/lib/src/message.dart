import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  const Message({
    required this.content,
    required this.from,
    required this.isRead,
    this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  final String content;
  final String from;
  final DateTime? timestamp;
  final bool isRead;

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [content, from, isRead, timestamp];
}

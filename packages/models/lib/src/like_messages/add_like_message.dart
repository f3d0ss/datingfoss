import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/like_messages/like_message.dart';

part 'add_like_message.g.dart';

@JsonSerializable()
class AddLikeMessage extends LikeMessage {
  const AddLikeMessage({
    required super.username,
    required this.keys,
  });

  factory AddLikeMessage.fromJson(Map<String, dynamic> json) =>
      _$AddLikeMessageFromJson(json);

  final List<String> keys;

  @override
  Map<String, dynamic> toJson() => _$AddLikeMessageToJson(this);

  @override
  List<Object?> get props => [username, keys];
}

import 'package:json_annotation/json_annotation.dart';
import 'package:models/src/like_messages/like_message.dart';

part 'remove_like_message.g.dart';

@JsonSerializable()
class RemoveLikeMessage extends LikeMessage {
  const RemoveLikeMessage({
    required super.username,
  });

  factory RemoveLikeMessage.fromJson(Map<String, dynamic> json) =>
      _$RemoveLikeMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RemoveLikeMessageToJson(this);
}

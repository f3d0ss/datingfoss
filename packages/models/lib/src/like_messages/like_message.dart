import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'like_message.g.dart';

@JsonSerializable()
class LikeMessage extends Equatable {
  const LikeMessage({
    required this.username,
  });

  factory LikeMessage.fromJson(Map<String, dynamic> json) =>
      _$LikeMessageFromJson(json);

  final String username;

  Map<String, dynamic> toJson() => _$LikeMessageToJson(this);

  @override
  List<Object?> get props => [username];
}

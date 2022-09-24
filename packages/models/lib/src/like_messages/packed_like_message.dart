import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'packed_like_message.g.dart';

@JsonSerializable()
class PackedLikeMessage extends Equatable {
  const PackedLikeMessage({
    required this.type,
    required this.likeMessage,
    required this.signedPartnerUsername,
  });

  factory PackedLikeMessage.fromJson(Map<String, dynamic> json) =>
      _$PackedLikeMessageFromJson(json);

  final String type;
  final Map<String, dynamic> likeMessage;
  final List<int> signedPartnerUsername;

  Map<String, dynamic> toJson() => _$PackedLikeMessageToJson(this);

  @override
  List<Object?> get props => [type, likeMessage, signedPartnerUsername];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packed_like_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackedLikeMessage _$PackedLikeMessageFromJson(Map<String, dynamic> json) =>
    PackedLikeMessage(
      type: json['type'] as String,
      likeMessage: json['likeMessage'] as Map<String, dynamic>,
      signedPartnerUsername: (json['signedPartnerUsername'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$PackedLikeMessageToJson(PackedLikeMessage instance) =>
    <String, dynamic>{
      'type': instance.type,
      'likeMessage': instance.likeMessage,
      'signedPartnerUsername': instance.signedPartnerUsername,
    };

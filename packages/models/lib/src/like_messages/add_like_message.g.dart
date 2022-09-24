// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_like_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddLikeMessage _$AddLikeMessageFromJson(Map<String, dynamic> json) =>
    AddLikeMessage(
      username: json['username'] as String,
      keys: (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AddLikeMessageToJson(AddLikeMessage instance) =>
    <String, dynamic>{
      'username': instance.username,
      'keys': instance.keys,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseUser _$BaseUserFromJson(Map<String, dynamic> json) => BaseUser(
      username: json['username'] as String,
      publicInfo:
          PublicInfo.fromJson(json['publicInfo'] as Map<String, dynamic>),
      privateInfoBase: json['privateInfoBase'] == null
          ? null
          : PrivateInfo.fromJson(
              json['privateInfoBase'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BaseUserToJson(BaseUser instance) => <String, dynamic>{
      'username': instance.username,
      'publicInfo': instance.publicInfo,
      'privateInfoBase': instance.privateInfoBase,
    };

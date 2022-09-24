// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      username: json['username'] as String,
      publicInfo:
          PublicInfoDTO.fromJson(json['publicInfo'] as Map<String, dynamic>),
      privateInfo:
          PrivateInfoDTO.fromJson(json['privateInfo'] as Map<String, dynamic>),
      publicKey: json['publicKey'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'username': instance.username,
      'publicInfo': instance.publicInfo,
      'privateInfo': instance.privateInfo,
      'publicKey': instance.publicKey,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenDTO _$TokenDTOFromJson(Map<String, dynamic> json) => TokenDTO(
      Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      json['serverSignedToken'] as String,
    );

Map<String, dynamic> _$TokenDTOToJson(TokenDTO instance) => <String, dynamic>{
      'challenge': instance.challenge,
      'serverSignedToken': instance.serverSignedToken,
    };

Challenge _$ChallengeFromJson(Map<String, dynamic> json) => Challenge(
      json['dataToSign'] as String,
      json['username'] as String,
      json['expirationDate'] as String,
    );

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'dataToSign': instance.dataToSign,
      'username': instance.username,
      'expirationDate': instance.expirationDate,
    };

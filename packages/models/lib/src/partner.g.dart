// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Partner _$PartnerFromJson(Map<String, dynamic> json) => Partner(
      username: json['username'] as String,
      publicInfo:
          PublicInfo.fromJson(json['publicInfo'] as Map<String, dynamic>),
      privateInfo: json['privateInfo'] == null
          ? null
          : PrivateInfo.fromJson(json['privateInfo'] as Map<String, dynamic>),
      jsonPublicKey: json['jsonPublicKey'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$PartnerToJson(Partner instance) => <String, dynamic>{
      'username': instance.username,
      'publicInfo': instance.publicInfo,
      'jsonPublicKey': instance.jsonPublicKey,
      'privateInfo': instance.privateInfo,
    };

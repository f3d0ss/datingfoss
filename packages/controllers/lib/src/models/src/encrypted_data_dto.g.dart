// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encrypted_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptedDataDTO _$EncryptedDataDTOFromJson(Map<String, dynamic> json) =>
    EncryptedDataDTO(
      json['encoded'] as String,
      json['keyIndex'] as int,
    );

Map<String, dynamic> _$EncryptedDataDTOToJson(EncryptedDataDTO instance) =>
    <String, dynamic>{
      'encoded': instance.encoded,
      'keyIndex': instance.keyIndex,
    };

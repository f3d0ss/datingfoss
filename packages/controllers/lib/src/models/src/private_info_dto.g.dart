// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateInfoDTO _$PrivateInfoDTOFromJson(Map<String, dynamic> json) =>
    PrivateInfoDTO(
      sex: json['sex'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['sex'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['location'] as Map<String, dynamic>),
      searching: json['searching'] == null
          ? null
          : EncryptedDataDTO.fromJson(
              json['searching'] as Map<String, dynamic>),
      textInfo: json['textInfo'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['textInfo'] as Map<String, dynamic>),
      dateInfo: json['dateInfo'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['dateInfo'] as Map<String, dynamic>),
      boolInfo: json['boolInfo'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['boolInfo'] as Map<String, dynamic>),
      bio: json['bio'] == null
          ? null
          : EncryptedDataDTO.fromJson(json['bio'] as Map<String, dynamic>),
      interests: json['interests'] == null
          ? null
          : EncryptedDataDTO.fromJson(
              json['interests'] as Map<String, dynamic>),
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => PrivatePictureDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrivateInfoDTOToJson(PrivateInfoDTO instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sex', instance.sex);
  writeNotNull('location', instance.location);
  writeNotNull('searching', instance.searching);
  writeNotNull('textInfo', instance.textInfo);
  writeNotNull('dateInfo', instance.dateInfo);
  writeNotNull('boolInfo', instance.boolInfo);
  writeNotNull('bio', instance.bio);
  writeNotNull('interests', instance.interests);
  writeNotNull('pictures', instance.pictures);
  return val;
}

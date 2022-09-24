// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicInfoDTO _$PublicInfoDTOFromJson(Map<String, dynamic> json) =>
    PublicInfoDTO(
      sex: (json['sex'] as num?)?.toDouble(),
      location: json['location'] == null
          ? null
          : LocationDTO.fromJson(json['location'] as Map<String, dynamic>),
      searching: json['searching'] == null
          ? null
          : RangeValuesDTO.fromJson(json['searching'] as Map<String, dynamic>),
      textInfo: (json['textInfo'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      dateInfo: (json['dateInfo'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, DateTime.parse(e as String)),
          ) ??
          const {},
      boolInfo: (json['boolInfo'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      bio: json['bio'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pictures: (json['pictures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PublicInfoDTOToJson(PublicInfoDTO instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sex', instance.sex);
  writeNotNull('location', instance.location);
  writeNotNull('searching', instance.searching);
  val['textInfo'] = instance.textInfo;
  val['dateInfo'] =
      instance.dateInfo.map((k, e) => MapEntry(k, e.toIso8601String()));
  val['boolInfo'] = instance.boolInfo;
  val['bio'] = instance.bio;
  val['interests'] = instance.interests;
  val['pictures'] = instance.pictures;
  return val;
}

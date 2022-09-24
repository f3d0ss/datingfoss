// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateInfo _$PrivateInfoFromJson(Map<String, dynamic> json) => PrivateInfo(
      sex: (json['sex'] as num?)?.toDouble(),
      location: json['location'] == null
          ? null
          : LatLng.fromJson(json['location'] as Map<String, dynamic>),
      searching: json['searching'] == null
          ? null
          : RangeValues.fromJson(json['searching'] as Map<String, dynamic>),
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
              ?.map((e) => PrivatePic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PrivateInfoToJson(PrivateInfo instance) =>
    <String, dynamic>{
      'sex': instance.sex,
      'location': instance.location,
      'searching': instance.searching,
      'textInfo': instance.textInfo,
      'dateInfo':
          instance.dateInfo.map((k, e) => MapEntry(k, e.toIso8601String())),
      'boolInfo': instance.boolInfo,
      'bio': instance.bio,
      'interests': instance.interests,
      'pictures': instance.pictures,
    };

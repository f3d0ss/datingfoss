// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'range_value_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RangeValuesDTO _$RangeValuesDTOFromJson(Map<String, dynamic> json) =>
    RangeValuesDTO(
      (json['start'] as num).toDouble(),
      (json['end'] as num).toDouble(),
    );

Map<String, dynamic> _$RangeValuesDTOToJson(RangeValuesDTO instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };

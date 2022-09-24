import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'range_value_dto.g.dart';

@JsonSerializable()
class RangeValuesDTO extends Equatable {
  const RangeValuesDTO(this.start, this.end);

  factory RangeValuesDTO.fromJson(Map<String, dynamic> json) =>
      _$RangeValuesDTOFromJson(json);

  final double start;
  final double end;
  @override
  List<Object?> get props => [start, end];

  Map<String, dynamic> toJson() => _$RangeValuesDTOToJson(this);
}

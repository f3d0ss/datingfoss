import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDTO extends Equatable {
  const LocationDTO(this.latitude, this.longitude);

  factory LocationDTO.fromJson(Map<String, dynamic> json) =>
      _$LocationDTOFromJson(json);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$LocationDTOToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}

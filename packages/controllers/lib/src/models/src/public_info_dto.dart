import 'package:controllers/controllers.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_info_dto.g.dart';

@JsonSerializable()
class PublicInfoDTO extends Equatable {
  const PublicInfoDTO({
    this.sex,
    this.location,
    this.searching,
    this.textInfo = const {},
    this.dateInfo = const {},
    this.boolInfo = const {},
    this.bio = '',
    this.interests = const [],
    this.pictures = const [],
  });

  factory PublicInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$PublicInfoDTOFromJson(json);

  final double? sex;
  final LocationDTO? location;
  final RangeValuesDTO? searching;
  final Map<String, String> textInfo;
  final Map<String, DateTime> dateInfo;
  final Map<String, bool> boolInfo;
  final String bio;
  final List<String> interests;
  final List<String> pictures;

  @override
  List<Object?> get props => [
        sex,
        location,
        searching,
        textInfo,
        dateInfo,
        boolInfo,
        bio,
        interests,
        pictures
      ];

  Map<String, dynamic> toJson() => _$PublicInfoDTOToJson(this);
}

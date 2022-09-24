import 'package:controllers/controllers.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'private_info_dto.g.dart';

@JsonSerializable()
class PrivateInfoDTO extends Equatable {
  const PrivateInfoDTO({
    this.sex,
    this.location,
    this.searching,
    this.textInfo,
    this.dateInfo,
    this.boolInfo,
    this.bio,
    this.interests,
    this.pictures,
  });

  factory PrivateInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$PrivateInfoDTOFromJson(json);

  final EncryptedDataDTO? sex;
  final EncryptedDataDTO? location;
  final EncryptedDataDTO? searching;
  final EncryptedDataDTO? textInfo;
  final EncryptedDataDTO? dateInfo;
  final EncryptedDataDTO? boolInfo;
  final EncryptedDataDTO? bio;
  final EncryptedDataDTO? interests;
  final List<PrivatePictureDTO>? pictures;

  List<String> get pictureIds => [...?pictures].map((p) => p.id).toList();

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

  Map<String, dynamic> toJson() => _$PrivateInfoDTOToJson(this);
}

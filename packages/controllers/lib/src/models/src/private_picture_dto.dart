import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'private_picture_dto.g.dart';

@JsonSerializable()
class PrivatePictureDTO extends Equatable {
  const PrivatePictureDTO({
    required this.id,
    required this.key,
  });

  factory PrivatePictureDTO.fromJson(Map<String, dynamic> json) =>
      _$PrivatePictureDTOFromJson(json);

  final String id;
  final int key;

  Map<String, dynamic> toJson() => _$PrivatePictureDTOToJson(this);

  @override
  List<Object?> get props => [id, key];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'private_pic.g.dart';

@JsonSerializable()
class PrivatePic extends Equatable {
  const PrivatePic({required this.picId, required this.keyIndex});

  factory PrivatePic.fromJson(Map<String, dynamic> json) =>
      _$PrivatePicFromJson(json);

  final String picId;
  final int keyIndex;

  Map<String, dynamic> toJson() => _$PrivatePicToJson(this);

  @override
  List<Object?> get props => [picId, keyIndex];
}

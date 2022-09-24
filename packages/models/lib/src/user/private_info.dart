import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/src/range_value.dart';
import 'package:models/src/user/private_pic.dart';

part 'private_info.g.dart';

@JsonSerializable()
class PrivateInfo extends Equatable {
  const PrivateInfo({
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

  factory PrivateInfo.fromJson(Map<String, dynamic> json) =>
      _$PrivateInfoFromJson(json);

  static const empty = PrivateInfo();

  Map<String, dynamic> toJson() => _$PrivateInfoToJson(this);

  PrivateInfo copyWith({
    double? Function()? sex,
    RangeValues? Function()? searching,
    LatLng? Function()? location,
    Map<String, String>? textInfo,
    Map<String, DateTime>? dateInfo,
    Map<String, bool>? boolInfo,
    String? bio,
    List<String>? interests,
    List<PrivatePic>? pictures,
  }) {
    return PrivateInfo(
      sex: sex != null ? sex() : this.sex,
      location: location != null ? location() : this.location,
      searching: searching != null ? searching() : this.searching,
      textInfo: textInfo ?? this.textInfo,
      dateInfo: dateInfo ?? this.dateInfo,
      boolInfo: boolInfo ?? this.boolInfo,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      pictures: pictures ?? this.pictures,
    );
  }

  final double? sex;
  final LatLng? location;
  final RangeValues? searching;
  final Map<String, String> textInfo;
  final Map<String, DateTime> dateInfo;
  final Map<String, bool> boolInfo;
  final String? bio;
  final List<String> interests;
  final List<PrivatePic> pictures;

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
}

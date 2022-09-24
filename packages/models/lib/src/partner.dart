import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';
import 'package:models/src/base_user.dart';

part 'partner.g.dart';

@JsonSerializable()
class Partner extends BaseUser {
  const Partner({
    required super.username,
    required super.publicInfo,
    PrivateInfo? privateInfo,
    required this.jsonPublicKey,
  }) : super(privateInfoBase: privateInfo);

  factory Partner.fromJson(Map<String, dynamic> json) =>
      _$PartnerFromJson(json);

  final Map<String, dynamic> jsonPublicKey;

  static const empty = Partner(
    username: '-',
    publicInfo: PublicInfo.empty,
    privateInfo: PrivateInfo.empty,
    jsonPublicKey: <String, dynamic>{},
  );

  @override
  Map<String, dynamic> toJson() => _$PartnerToJson(this);

  Partner copyWithPrivateData({required PrivateInfo privateInfo}) {
    return Partner(
      username: username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
      jsonPublicKey: jsonPublicKey,
    );
  }

  PrivateInfo? get privateInfo => privateInfoBase;
}

import 'package:controllers/controllers.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDTO {
  const UserDTO({
    required this.username,
    required this.publicInfo,
    required this.privateInfo,
    required this.publicKey,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  final String username;
  final PublicInfoDTO publicInfo;
  final PrivateInfoDTO privateInfo;
  final Map<String, dynamic> publicKey;

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'token_dto.g.dart';

@JsonSerializable()
class TokenDTO {
  TokenDTO(this.challenge, this.serverSignedToken);

  factory TokenDTO.fromJson(Map<String, dynamic> json) =>
      _$TokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$TokenDTOToJson(this);

  final Challenge challenge;
  final String serverSignedToken;
}

@JsonSerializable()
class Challenge {
  Challenge(this.dataToSign, this.username, this.expirationDate);

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  final String dataToSign;
  final String username;
  final String expirationDate;
}

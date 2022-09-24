import 'package:json_annotation/json_annotation.dart';

part 'encrypted_data_dto.g.dart';

@JsonSerializable()
class EncryptedDataDTO {
  const EncryptedDataDTO(this.encoded, this.keyIndex);

  factory EncryptedDataDTO.fromJson(Map<String, dynamic> json) =>
      _$EncryptedDataDTOFromJson(json);

  final String encoded;
  final int keyIndex;

  Map<String, dynamic> toJson() => _$EncryptedDataDTOToJson(this);
}

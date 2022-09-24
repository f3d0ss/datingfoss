import 'package:controllers/controllers.dart';
import 'package:models/models.dart';

extension PublicInfoExtension on PublicInfo {
  PublicInfoDTO get toPublicInfoDTO {
    return PublicInfoDTO(
      sex: sex,
      location: location != null
          ? LocationDTO(
              location!.latitude,
              location!.longitude,
            )
          : null,
      searching: searching != null
          ? RangeValuesDTO(
              searching!.start,
              searching!.end,
            )
          : null,
      textInfo: textInfo,
      dateInfo: dateInfo,
      boolInfo: boolInfo,
      bio: bio,
      interests: interests,
    );
  }
}

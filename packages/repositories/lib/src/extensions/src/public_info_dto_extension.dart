import 'package:controllers/controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

extension PublicInfoDTOExtension on PublicInfoDTO {
  PublicInfo toLocalPublicInfo({List<String>? pics}) {
    return PublicInfo(
      sex: sex,
      location: location != null
          ? LatLng(
              location!.latitude,
              location!.longitude,
            )
          : null,
      searching: searching != null
          ? RangeValues(
              searching!.start,
              searching!.end,
            )
          : null,
      textInfo: textInfo,
      dateInfo: dateInfo,
      boolInfo: boolInfo,
      bio: bio,
      interests: interests,
      pictures: pics ?? pictures,
    );
  }
}

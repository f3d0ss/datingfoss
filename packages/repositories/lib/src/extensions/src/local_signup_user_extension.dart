import 'package:controllers/controllers.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart' as models;
import 'package:repositories/repositories.dart';
import 'package:services/services.dart';

extension FromLocalSignupUserToUserDTO on models.LocalSignupUser {
  Future<UserDTO> toUserDTO({
    required AsymmetricEncryptionService asymmetricEncryptionService,
    required SymmetricEncryptionService symmetricEncryptionService,
    List<String>? partnersThatILike,
  }) async {
    return UserDTO(
      username: username!,
      publicKey: asymmetricEncryptionService.jsonPublicKey,
      publicInfo: publicInfo.toPublicInfoDTO,
      privateInfo: privateInfo.toPrivateInfoDTO(
        encryptionService: symmetricEncryptionService,
        username: username!,
      ),
    );
  }

  models.LocalUser toLocalUser() {
    return models.LocalUser(
      username: username!,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
  }

  models.PublicInfo get publicInfo {
    final publicBoolInfo = _getBoolInfo();

    final publicTextInfo = _getTextInfo();

    final publicDateInfo = _getDateInfo();

    final publicSearching = _getSearching();

    final publicSex = _getSex();

    final publicLocation = _getLocation();

    return models.PublicInfo(
      boolInfo: publicBoolInfo,
      textInfo: publicTextInfo,
      dateInfo: publicDateInfo,
      bio: bio ?? '',
      interests: interests ?? [],
      location: publicLocation,
      pictures: (pictures ?? []).map((e) => e.path).toList(),
      searching: publicSearching,
      sex: publicSex,
    );
  }

  models.PrivateInfo get privateInfo {
    final privateBoolInfo = _getBoolInfo(private: true);

    final privateTextInfo = _getTextInfo(private: true);

    final privateDateInfo = _getDateInfo(private: true);

    final privateSearching = _getSearching(private: true);

    final privateSex = _getSex(private: true);

    final privateLocation = _getLocation(private: true);

    return models.PrivateInfo(
      boolInfo: privateBoolInfo,
      textInfo: privateTextInfo,
      dateInfo: privateDateInfo,
      bio: privateBio ?? '',
      interests: privateInsterests ?? [],
      location: privateLocation,
      pictures: (privatePictures ?? [])
          .map((e) => models.PrivatePic(picId: e.path, keyIndex: 0))
          .toList(),
      searching: privateSearching,
      sex: privateSex,
    );
  }

  double? _getSex({bool private = false}) => sex?.getIf(ifPrivate: private);

  models.RangeValues? _getSearching({bool private = false}) =>
      searching?.getIf(ifPrivate: private);

  LatLng? _getLocation({bool private = false}) =>
      location?.getIf(ifPrivate: private);

  Map<String, DateTime> _getDateInfo({bool private = false}) {
    final signupPublicDateInfo = {...?dateInfo}
      ..removeWhere((key, value) => private != value.private);
    return signupPublicDateInfo
        .map<String, DateTime>((key, value) => MapEntry(key, value.data));
  }

  Map<String, String> _getTextInfo({bool private = false}) {
    final signupPublicTextInfo = {...?textInfo}
      ..removeWhere((key, value) => private != value.private);
    return signupPublicTextInfo
        .map<String, String>((key, value) => MapEntry(key, value.data));
  }

  Map<String, bool> _getBoolInfo({bool private = false}) {
    final signupPublicBoolInfo = {...?boolInfo}
      ..removeWhere((key, value) => private != value.private);
    return signupPublicBoolInfo
        .map<String, bool>((key, value) => MapEntry(key, value.data));
  }
}

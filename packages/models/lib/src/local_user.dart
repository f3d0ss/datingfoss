import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';
import 'package:models/src/base_user.dart';

class LocalUser extends BaseUser {
  const LocalUser({
    required super.username,
    required super.publicInfo,
    required PrivateInfo privateInfo,
  }) : super(privateInfoBase: privateInfo);

  LocalUser copyWithPrivateData({required PrivateInfo privateInfo}) {
    return LocalUser(
      username: username,
      publicInfo: publicInfo,
      privateInfo: privateInfo,
    );
  }

  static const empty = LocalUser(
    username: '-',
    publicInfo: PublicInfo.empty,
    privateInfo: PrivateInfo.empty,
  );

  /// Convenience getter to determine whether the current user is empty.
  @override
  bool get isEmpty => this == LocalUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  @override
  bool get isNotEmpty => this != LocalUser.empty;

  PrivateInfo get privateInfo => privateInfoBase!;

  double? getDistance({required LatLng from}) {
    late LatLng? location;

    location = privateInfoBase!.location ?? publicInfo.location;

    if (location == null) {
      return null;
    }
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, location, from);
  }

  @override
  List<Object?> get props => [username, publicInfo, privateInfoBase];
}

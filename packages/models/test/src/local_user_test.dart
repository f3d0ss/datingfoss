// ignore_for_file: prefer_const_constructors
import 'package:latlong2/latlong.dart';
import 'package:models/src/local_user.dart';
import 'package:models/src/user/private_info.dart';
import 'package:models/src/user/public_info.dart';
import 'package:test/test.dart';

void main() {
  group('LocalUser', () {
    late LocalUser localUser;
    late PublicInfo publicInfo;
    late PrivateInfo privateInfo;
    setUp(() {
      publicInfo = PublicInfo(location: LatLng(0, 0));
      privateInfo = PrivateInfo();
      localUser = LocalUser(
        username: 'username',
        publicInfo: publicInfo,
        privateInfo: privateInfo,
      );
    });
    test('can compare', () {
      expect(
        localUser,
        localUser.copyWithPrivateData(privateInfo: privateInfo),
      );
    });

    test('get isEmpty isNotEmpty', () {
      expect(localUser.isEmpty, false);
      expect(localUser.isNotEmpty, true);
    });
    test('get privateInfo', () {
      expect(localUser.privateInfo, privateInfo);
    });

    test('getDistance', () {
      localUser.getDistance(from: LatLng(0, 0));
    });
  });
}

// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:models/src/partner.dart';
import 'package:models/src/user/private_info.dart';
import 'package:models/src/user/public_info.dart';
import 'package:test/test.dart';

void main() {
  group('Partner', () {
    late Partner partner;
    late PublicInfo publicInfo;
    late PrivateInfo privateInfo;
    late Map<String, dynamic> jsonPublicKey;
    setUp(() {
      jsonPublicKey = <String, dynamic>{};
      publicInfo = PublicInfo(location: LatLng(0, 0));
      privateInfo = PrivateInfo();
      partner = Partner(
        username: 'username',
        publicInfo: publicInfo,
        privateInfo: privateInfo,
        jsonPublicKey: jsonPublicKey,
      );
    });
    test('can compare', () {
      expect(
        partner,
        partner.copyWithPrivateData(privateInfo: privateInfo),
      );
    });

    test('get isEmpty isNotEmpty', () {
      expect(partner.isEmpty, false);
      expect(partner.isNotEmpty, true);
    });
    test('get privateInfo', () {
      expect(partner.privateInfo, privateInfo);
    });

    test('get go to json and back', () {
      expect(partner, Partner.fromJson(encodeJson(partner.toJson())));
    });
  });
}

Map<String, dynamic> encodeJson(Map<String, dynamic> object) =>
    json.decode(json.encode(object)) as Map<String, dynamic>;

// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:models/src/base_user.dart';
import 'package:models/src/range_value.dart';
import 'package:models/src/user/private_info.dart';
import 'package:models/src/user/public_info.dart';
import 'package:test/test.dart';

void main() {
  group('BaseUser', () {
    late BaseUser alice;
    late BaseUser bob;
    late BaseUser carl;
    late PublicInfo publicInfo;
    late PrivateInfo privateInfo;

    setUp(() {
      publicInfo = PublicInfo();
      privateInfo = PrivateInfo();
      alice = BaseUser(
        username: 'alice',
        publicInfo: publicInfo,
        privateInfoBase: privateInfo,
      );
      bob = BaseUser(
        username: 'bob',
        publicInfo: publicInfo.copyWith(
          textInfo: const {'name': 'bob', 'surname': 'Sur bob'},
          dateInfo: {'birthdate': DateTime(1990)},
          boolInfo: const {'smocker': false},
          interests: const ['shopping'],
          sex: () => 0,
          searching: () => RangeValues(0, 1),
          location: () => LatLng(0, 0),
          bio: "I'm Bob",
        ),
        privateInfoBase: privateInfo.copyWith(),
      );
      carl = BaseUser(
        username: 'carl',
        publicInfo: publicInfo.copyWith(),
        privateInfoBase: privateInfo.copyWith(
          textInfo: const {'name': 'carl', 'surname': 'Sur carl'},
          dateInfo: {'birthdate': DateTime(1990)},
          boolInfo: const {'smocker': false},
          interests: const ['shopping'],
          sex: () => 0,
          searching: () => RangeValues(0, 1),
          location: () => LatLng(0, 0),
          bio: "I'm Carl",
        ),
      );
    });

    test('get go to json and back', () {
      expect(alice, BaseUser.fromJson(encodeJson(alice.toJson())));
    });

    test('can get hasPrivateInfo', () {
      alice.hasPrivateInfo;
    });

    test('can get age', () {
      alice.age;
      bob.age;
      carl.age;
    });

    test('can get privateBioOrPublicBio', () {
      alice.privateBioOrPublicBio;
      bob.privateBioOrPublicBio;
      carl.privateBioOrPublicBio;
    });

    test('can get isEmpty', () {
      alice.isEmpty;
      bob.isNotEmpty;
    });

    test('can get name', () {
      alice.name;
      bob.name;
      carl.name;
    });

    test('can get surname', () {
      alice.surname;
      bob.surname;
      carl.surname;
    });

    test('can get textInfo', () {
      alice.textInfo;
      bob.textInfo;
      carl.textInfo;
    });

    test('can get dateInfo', () {
      alice.dateInfo;
      bob.dateInfo;
      carl.dateInfo;
    });

    test('can get boolInfo', () {
      alice.boolInfo;
      bob.boolInfo;
      carl.boolInfo;
    });

    test('can get interests', () {
      alice.interests;
      bob.interests;
      carl.interests;
    });

    test('can get sex', () {
      alice.sex;
      bob.sex;
      carl.sex;
    });

    test('can get searching', () {
      alice.searching;
      bob.searching;
      carl.searching;
    });

    test('can get location', () {
      alice.location;
      bob.location;
      carl.location;
    });

    test('can get commonableInterest', () {
      alice.commonableInterest(['shopping']);
      bob.commonableInterest(['shopping']);
      carl.commonableInterest(['shopping']);
    });
  });
}

Map<String, dynamic> encodeJson(Map<String, dynamic> object) =>
    json.decode(json.encode(object)) as Map<String, dynamic>;

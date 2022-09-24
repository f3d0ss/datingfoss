import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class LocalSignupUser {
  const LocalSignupUser({
    this.password,
    this.username,
    this.sex,
    this.location,
    this.searching,
    this.textInfo,
    this.dateInfo,
    this.boolInfo,
    this.bio,
    this.privateBio,
    this.interests,
    this.privateInsterests,
    this.pictures,
    this.privatePictures,
  });

  final String? username;
  final String? password;
  final PrivateData<double>? sex;
  final PrivateData<LatLng>? location;
  final PrivateData<RangeValues>? searching;
  final Map<String, PrivateData<String>>? textInfo;
  final Map<String, PrivateData<DateTime>>? dateInfo;
  final Map<String, PrivateData<bool>>? boolInfo;
  final String? bio;
  final String? privateBio;
  final List<String>? interests;
  final List<String>? privateInsterests;
  final List<File>? pictures;
  final List<File>? privatePictures;

  LocalSignupUser copyWith({
    String? username,
    String? password,
    PrivateData<double>? sex,
    PrivateData<LatLng>? location,
    PrivateData<RangeValues>? searching,
    Map<String, PrivateData<String>>? textInfo,
    Map<String, PrivateData<DateTime>>? dateInfo,
    Map<String, PrivateData<bool>>? boolInfo,
    String? bio,
    String? privateBio,
    List<String>? interests,
    List<String>? privateInsterests,
    List<File>? pictures,
    List<File>? privatePictures,
  }) {
    return LocalSignupUser(
      password: password ?? this.password,
      username: username ?? this.username,
      sex: sex ?? this.sex,
      location: location ?? this.location,
      searching: searching ?? this.searching,
      textInfo: textInfo ?? this.textInfo,
      dateInfo: dateInfo ?? this.dateInfo,
      boolInfo: boolInfo ?? this.boolInfo,
      bio: bio ?? this.bio,
      privateBio: privateBio ?? this.privateBio,
      interests: interests ?? this.interests,
      privateInsterests: privateInsterests ?? this.privateInsterests,
      pictures: pictures ?? this.pictures,
      privatePictures: privatePictures ?? this.privatePictures,
    );
  }

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == LocalSignupUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != LocalSignupUser.empty;

  static const empty = LocalSignupUser();
}

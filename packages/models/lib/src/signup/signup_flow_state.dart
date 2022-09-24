import 'dart:io';

import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

enum SignupStatus {
  initial,
  selectingLocation,
  selectingSexAndOrientation,
  selectingStandardInfo,
  selectingPublicInterests,
  selectingPrivateInterests,
  selectingPublicBio,
  selectingPrivateBio,
  selectingPublicPictures,
  selectingPrivatePictures,
  completed,
}

class SignupFlowState {
  const SignupFlowState({
    this.localUser = LocalSignupUser.empty,
    this.signupStatus = SignupStatus.initial,
  });

  final LocalSignupUser localUser;
  final SignupStatus signupStatus;

  SignupFlowState copyWith({
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
    SignupStatus? signupStatus,
  }) {
    return SignupFlowState(
      localUser: localUser.copyWith(
        username: username,
        password: password,
        sex: sex,
        location: location,
        searching: searching,
        textInfo: textInfo,
        dateInfo: dateInfo,
        boolInfo: boolInfo,
        bio: bio,
        privateBio: privateBio,
        interests: interests,
        privateInsterests: privateInsterests,
        pictures: pictures,
        privatePictures: privatePictures,
      ),
      signupStatus: signupStatus ?? this.signupStatus,
    );
  }
}

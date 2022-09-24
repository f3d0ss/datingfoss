part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class StandardInfoEdited extends ProfileEvent {
  const StandardInfoEdited(this.standardInfo);

  final StandardInfo standardInfo;
}

class InterestsEdited extends ProfileEvent {
  const InterestsEdited({required this.interests, required this.private});

  final List<String> interests;
  final bool private;
}

class BioEdited extends ProfileEvent {
  const BioEdited({required this.bio, required this.private});

  final String bio;
  final bool private;
}

class PicDeleted extends ProfileEvent {
  const PicDeleted({required this.picId, required this.private});

  final String picId;
  final bool private;
}

class PicAdded extends ProfileEvent {
  const PicAdded({required this.private, required this.pic});

  final File? pic;
  final bool private;
}

class LocationEdited extends ProfileEvent {
  const LocationEdited({
    required this.latitude,
    required this.longitude,
    required this.private,
  });

  final double latitude;
  final double longitude;
  final bool private;
}

class SexAndOrientationEdited extends ProfileEvent {
  const SexAndOrientationEdited({required this.searching, required this.sex});

  final PrivateData<RangeValues> searching;
  final PrivateData<double> sex;
}

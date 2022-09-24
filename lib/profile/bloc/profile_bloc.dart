import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required UserRepository userRepository})
      : _authenticationRepository = userRepository,
        super(ProfileState(userRepository.currentUser)) {
    on<StandardInfoEdited>(_onStandardInfoEdited);
    on<InterestsEdited>(_onInterestsEdited);
    on<BioEdited>(_onBioEdited);
    on<PicAdded>(_onPicAdded);
    on<SexAndOrientationEdited>(_onSexAndOrientationEdited);
    on<PicDeleted>(_onPicDeleted);
    on<LocationEdited>(_onLocationEdited);
  }

  final UserRepository _authenticationRepository;

  Future<void> _onStandardInfoEdited(
    StandardInfoEdited event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.editStandardInfo(event.standardInfo);
  }

  Future<void> _onInterestsEdited(
    InterestsEdited event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.editInterests(
      private: event.private,
      interests: event.interests,
    );
  }

  Future<void> _onBioEdited(
    BioEdited event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.editBio(
      private: event.private,
      bio: event.bio,
    );
  }

  Future<void> _onPicAdded(
    PicAdded event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.pic != null) {
      await _authenticationRepository.addPic(
        pic: event.pic!,
        private: event.private,
      );
    }
  }

  Future<void> _onPicDeleted(
    PicDeleted event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.deletePic(
      picId: event.picId,
      private: event.private,
    );
  }

  Future<void> _onSexAndOrientationEdited(
    SexAndOrientationEdited event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.editSexAndOrientation(
      sex: event.sex.data,
      isSexPrivate: event.sex.private,
      searching: event.searching.data,
      isSearchingPrivate: event.searching.private,
    );
  }

  Future<void> _onLocationEdited(
    LocationEdited event,
    Emitter<ProfileState> emit,
  ) async {
    await _authenticationRepository.editLocation(
      latitude: event.latitude,
      longitude: event.longitude,
      private: event.private,
    );
  }
}

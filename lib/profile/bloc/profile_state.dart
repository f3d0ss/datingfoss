part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState(this.editedUser);

  final LocalUser editedUser;

  @override
  List<Object> get props => [];
}

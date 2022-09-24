part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends LoginEvent {
  const UsernameChanged(this.username);

  final String username;
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;
}

class Submitted extends LoginEvent {}

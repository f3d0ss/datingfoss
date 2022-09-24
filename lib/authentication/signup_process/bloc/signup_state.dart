part of 'signup_bloc.dart';

class SignupState extends Equatable {
  const SignupState({this.signupBlocState = SignupBlocState.initial});

  final SignupBlocState signupBlocState;

  @override
  List<Object> get props => [signupBlocState];
}

enum SignupBlocState {
  initial,
  loading,
  signedUp,
}

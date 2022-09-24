part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = CredentialStatus.editing,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isCheckingUsername = false,
  });

  final CredentialStatus status;
  final Username username;
  final Password password;
  final bool isCheckingUsername;

  LoginState copyWith({
    CredentialStatus? status,
    Username? username,
    Password? password,
    bool? isCheckingUsername,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
    );
  }

  bool get isBusy {
    return isCheckingUsername || status == CredentialStatus.submitting;
  }

  bool get canSubmit {
    return Formz.validate([username, password]) == FormzStatus.valid && !isBusy;
  }

  @override
  List<Object> get props => [status, username, password, isCheckingUsername];
}

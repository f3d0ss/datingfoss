import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:datingfoss/authentication/login/bloc/credential_status.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required UserRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<UsernameChanged>(
      _usernameChanged,
      transformer: debounceRestartable(debounceUsernameDuration),
    );
    on<PasswordChanged>(_passwordChanged);
    on<Submitted>(_submitted);
  }

  // How long to wait after the last keypress event before checking
  // if username exist.
  static const debounceUsernameDuration = Duration(milliseconds: 400);

  final UserRepository _authenticationRepository;

  Future<void> _usernameChanged(
    UsernameChanged event,
    Emitter<LoginState> emit,
  ) async {
    var username = Username.dirty(value: event.username);
    emit(
      state.copyWith(
        username: username,
        isCheckingUsername: username.valid,
      ),
    );

    if (username.valid) {
      final doesUsernameExist =
          await _authenticationRepository.doesUserExist(username.value);
      if (!doesUsernameExist) {
        username = Username.dirty(
          value: event.username,
          serverError: UsernameValidationError.notExist,
        );
      }
      emit(
        state.copyWith(
          username: username,
          isCheckingUsername: false,
        ),
      );
    }
  }

  void _passwordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(value: event.password);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  Future<void> _submitted(Submitted event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: CredentialStatus.submitting));
    try {
      await _authenticationRepository.logInWithUsernameAndPassword(
        username: state.username.value,
        password: state.password.value,
      );
    } catch (e) {
      if (e is ArgumentError) {
        emit(
          state.copyWith(
            username: Username.dirty(
              value: state.username.value,
              serverError: UsernameValidationError.notExist,
            ),
            status: CredentialStatus.failed,
          ),
        );
      }
      emit(
        state.copyWith(
          status: CredentialStatus.failed,
        ),
      );
    }
  }
}

EventTransformer<RegistrationEvent> debounceRestartable<RegistrationEvent>(
  Duration duration,
) {
  return (events, mapper) => restartable<RegistrationEvent>()
      .call(events.debounceTime(duration), mapper);
}

import 'package:bloc/bloc.dart';
import 'package:datingfoss/authentication/login/bloc/credential_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'signup_credential_state.dart';

class SignupCredentialCubit extends Cubit<SignupCredentialState> {
  SignupCredentialCubit({
    required UserRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const SignupCredentialState());

  final UserRepository _authenticationRepository;

  Future<void> usernameChanged(String editedUsername) async {
    var username = Username.dirty(value: editedUsername);
    emit(
      state.copyWith(
        username: username,
        isCheckingUsername: username.valid,
      ),
    );

    if (username.valid) {
      final isUsernameAvailable =
          await _authenticationRepository.isUsernameAvailable(username.value);
      if (!isUsernameAvailable) {
        username = Username.dirty(
          value: editedUsername,
          serverError: UsernameValidationError.taken,
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

  void passwordChanged(String editedPassword) {
    final password = Password.dirty(value: editedPassword);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  Future<void> submitted(FlowController<SignupFlowState> flow) async {
    emit(state.copyWith(status: CredentialStatus.submitting));
    try {
      final isAvailable = await _authenticationRepository
          .isUsernameAvailable(state.username.value);
      if (isAvailable) {
        flow.update(
          (flowState) => flowState.copyWith(
            signupStatus: SignupStatus.selectingLocation,
            username: state.username.value,
            password: state.username.value,
          ),
        );
        emit(state.copyWith(status: CredentialStatus.editing));
      } else {
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
    } catch (_) {
      emit(state.copyWith(status: CredentialStatus.failed));
    }
  }
}

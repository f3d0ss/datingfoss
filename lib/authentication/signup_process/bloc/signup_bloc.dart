import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({required UserRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const SignupState()) {
    on<SignupRequested>(_signupEvent);
  }

  final UserRepository _authenticationRepository;

  Future<void> _signupEvent(
    SignupRequested event,
    Emitter<SignupState> emit,
  ) async {
    final signupUser = event.user;
    if (signupUser.username != null) {
      emit(const SignupState(signupBlocState: SignupBlocState.loading));
      await _authenticationRepository.signUp(signupUser: signupUser);
      emit(const SignupState(signupBlocState: SignupBlocState.signedUp));
    }
  }
}

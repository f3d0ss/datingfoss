import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:datingfoss/authentication/widgets/authentication_screen.dart';
import 'package:datingfoss/authentication/widgets/authentication_second_button.dart';
import 'package:datingfoss/authentication/widgets/authentication_submit_button.dart';
import 'package:datingfoss/authentication/widgets/password_input.dart';
import 'package:datingfoss/authentication/widgets/username_input.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class SignUpCredential extends StatelessWidget {
  const SignUpCredential({super.key});
  @override
  Widget build(BuildContext context) {
    final signupCubit = context.buildCubit<SignupCredentialCubit>();
    return BlocProvider.value(
      value: signupCubit,
      child: AuthenticationScreen(
        usernameInput:
            BlocBuilder<SignupCredentialCubit, SignupCredentialState>(
          builder: (context, state) {
            return UsernameInput(
              username: state.username,
              isCheckingUsername: state.isCheckingUsername,
              onChanged: signupCubit.usernameChanged,
            );
          },
        ),
        passwordInput:
            BlocBuilder<SignupCredentialCubit, SignupCredentialState>(
          builder: (context, state) {
            return PasswordInput(
              password: state.password,
              onChanged: signupCubit.passwordChanged,
            );
          },
        ),
        mainButton: BlocBuilder<SignupCredentialCubit, SignupCredentialState>(
          builder: (context, state) {
            return AuthenticationSubmitButton(
              canSubmit: state.canSubmit,
              onPressed: () =>
                  signupCubit.submitted(context.flow<SignupFlowState>()),
              status: state.status,
              title: 'SIGNUP',
              icon: Icons.add_reaction_rounded,
            );
          },
        ),
        secondaryButton:
            BlocBuilder<SignupCredentialCubit, SignupCredentialState>(
          builder: (context, state) {
            return AuthenticationSecondButton(
              title: 'LOGIN',
              onPressed: () => context.flow<SignupFlowState>().complete(),
              icon: Icons.favorite,
            );
          },
        ),
      ),
    );
  }
}

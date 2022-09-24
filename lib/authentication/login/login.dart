import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/authentication/signup_process/signup.dart';
import 'package:datingfoss/authentication/widgets/authentication_screen.dart';
import 'package:datingfoss/authentication/widgets/authentication_second_button.dart';
import 'package:datingfoss/authentication/widgets/authentication_submit_button.dart';
import 'package:datingfoss/authentication/widgets/password_input.dart';
import 'package:datingfoss/authentication/widgets/username_input.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginScreen());

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.buildBloc<LoginBloc>();
    return BlocProvider.value(
      value: loginBloc,
      child: AuthenticationScreen(
        usernameInput: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return UsernameInput(
              username: state.username,
              isCheckingUsername: state.isCheckingUsername,
              onChanged: (username) => loginBloc.add(UsernameChanged(username)),
            );
          },
        ),
        passwordInput: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return PasswordInput(
              password: state.password,
              onChanged: (password) => loginBloc.add(PasswordChanged(password)),
            );
          },
        ),
        mainButton: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return AuthenticationSubmitButton(
              canSubmit: state.canSubmit,
              onPressed: () => loginBloc.add(Submitted()),
              status: state.status,
              title: 'LOGIN',
              icon: Icons.favorite,
            );
          },
        ),
        secondaryButton: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return AuthenticationSecondButton(
              onPressed: () => Navigator.of(context).push(SignUpFlow.route()),
              title: 'SIGNUP',
              icon: Icons.add_reaction_rounded,
            );
          },
        ),
      ),
    );
  }
}

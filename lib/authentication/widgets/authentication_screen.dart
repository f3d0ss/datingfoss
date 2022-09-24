import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({
    super.key,
    required this.usernameInput,
    required this.passwordInput,
    required this.mainButton,
    required this.secondaryButton,
  });

  final Widget usernameInput;
  final Widget passwordInput;
  final Widget mainButton;
  final Widget secondaryButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.tertiary
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 450, maxWidth: 500),
            child: ListView(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    usernameInput,
                    const SizedBox(height: 20),
                    passwordInput,
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: secondaryButton,
                    ),
                    Expanded(
                      child: mainButton,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

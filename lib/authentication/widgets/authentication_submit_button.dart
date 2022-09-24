import 'package:datingfoss/authentication/login/bloc/credential_status.dart';
import 'package:flutter/material.dart';

class AuthenticationSubmitButton extends StatelessWidget {
  const AuthenticationSubmitButton({
    super.key,
    required this.status,
    required this.canSubmit,
    required this.onPressed,
    required this.title,
    required this.icon,
  });

  final CredentialStatus status;
  final bool canSubmit;
  final void Function() onPressed;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (status == CredentialStatus.submitting)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(6),
              child: CircularProgressIndicator(),
            ),
          )
        else
          Container(),
        Opacity(
          opacity: canSubmit ? 1 : 0.5,
          child: Center(
            child: ElevatedButton.icon(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: canSubmit ? onPressed : null,
              icon: Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

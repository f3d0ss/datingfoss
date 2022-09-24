import 'package:flutter/material.dart';

class AuthenticationSecondButton extends StatelessWidget {
  const AuthenticationSecondButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
  });

  final void Function() onPressed;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
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
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          label: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

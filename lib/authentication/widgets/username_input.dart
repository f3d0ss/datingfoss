import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

class UsernameInput extends StatelessWidget {
  const UsernameInput({
    required this.username,
    required this.isCheckingUsername,
    required this.onChanged,
    super.key,
  });

  final Username username;
  final bool isCheckingUsername;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        prefixIcon: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        errorText: _usernameError(username),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffix: isCheckingUsername
            ? ConstrainedBox(
                constraints: BoxConstraints.tight(const Size(15, 15)),
                child: const CircularProgressIndicator(strokeWidth: 3),
              )
            : null,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withAlpha(80),
        ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  String? _usernameError(Username username) {
    final error = username.displayError;
    if (error == null) return null;
    if (error == UsernameValidationError.empty) {
      return 'Username cannot be empty';
    } else if (error == UsernameValidationError.invalid) {
      return 'Invalid Username';
    } else if (error == UsernameValidationError.notExist) {
      return 'Username do not exist';
    } else if (error == UsernameValidationError.taken) {
      return 'Username already taken';
    }
    return null;
  }
}

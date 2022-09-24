import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    required this.password,
    required this.onChanged,
    super.key,
  });

  final Password password;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(16),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        prefixIcon:
            Icon(Icons.key, color: Theme.of(context).colorScheme.primary),
        errorText: _passwordError(password),
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withAlpha(80),
        ),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      obscureText: true,
    );
  }

  String? _passwordError(Password password) {
    final error = password.displayError;
    if (error == null) return null;
    if (error == PasswordValidationError.empty) {
      return 'Password cannot be empty';
    } else if (error == PasswordValidationError.invalid) {
      return 'Invalid password';
    }
    return null;
  }
}

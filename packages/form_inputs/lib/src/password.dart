import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid,
  empty,
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  /// {@macro password}
  const Password.pure({String value = '', this.serverError})
      : super.pure(value);

  /// {@macro password}
  const Password.dirty({String value = '', this.serverError})
      : super.dirty(value);

  final PasswordValidationError? serverError;

  PasswordValidationError? get displayError => pure ? null : super.error;

  @override
  PasswordValidationError? validator(String? value) {
    final error = serverError;
    if (error != null) return error;
    if (!_passwordRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalid;
    }
    return null;
  }
}

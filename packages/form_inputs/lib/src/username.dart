import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum UsernameValidationError {
  /// Generic invalid error.
  invalid,
  empty,
  taken,
  notExist,
}

/// {@template username}
/// Form input for an username input.
/// {@endtemplate}
class Username extends FormzInput<String, UsernameValidationError> {
  static final RegExp _usernameRegExp = RegExp(
    r'^[a-z0-9_-]{3,15}$',
  );

  /// {@macro username}
  const Username.pure({String value = '', this.serverError})
      : super.pure(value);

  /// {@macro username}
  const Username.dirty({String value = '', this.serverError})
      : super.dirty(value);

  final UsernameValidationError? serverError;

  UsernameValidationError? get displayError => pure ? null : super.error;

  @override
  UsernameValidationError? validator(String? value) {
    final error = serverError;
    if (error != null) return error;
    if (!_usernameRegExp.hasMatch(value ?? '')) {
      return UsernameValidationError.invalid;
    }
    return null;
  }
}

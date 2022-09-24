import 'package:models/models.dart';

abstract class InputInfo<T> {
  const InputInfo._(this.data, [this.pure = true]);

  const InputInfo.pure(PrivateData<T> data) : this._(data);

  const InputInfo.dirty(PrivateData<T> data) : this._(data, false);

  final PrivateData<T> data;
  final bool pure;

  InputInfoValidationError? validate();

  InputInfoValidationError? get error => validate();
}

enum InputInfoValidationError { empty }

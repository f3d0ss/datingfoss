import 'package:models/models.dart';

enum TextInfoValidationError { empty }

class TextInfo extends InputInfo<String> {
  const TextInfo.pure(super.data) : super.pure();

  const TextInfo.dirty(super.data) : super.dirty();

  @override
  InputInfoValidationError? validate() => pure
      ? null
      : (data.data.isNotEmpty == true)
          ? null
          : InputInfoValidationError.empty;
}

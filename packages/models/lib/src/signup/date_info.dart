import 'package:models/models.dart';

enum DateInfoValidationError { empty }

class DateInfo extends InputInfo<DateTime?> {
  const DateInfo.pure(super.data) : super.pure();

  const DateInfo.dirty(super.data) : super.dirty();

  @override
  InputInfoValidationError? validate() => pure
      ? null
      : (data.data != null && data.data!.isBefore(DateTime.now()))
          ? null
          : InputInfoValidationError.empty;
}

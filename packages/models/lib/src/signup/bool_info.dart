import 'package:models/models.dart';

enum BoolInfoValidationError { empty }

class BoolInfo extends InputInfo<bool> {
  const BoolInfo(super.data) : super.dirty();

  @override
  InputInfoValidationError? validate() => null;
}

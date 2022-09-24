import 'package:models/src/signup/private_data.dart';

class CommonableInterest extends PrivateData<String> {
  const CommonableInterest(
    super.data, {
    required this.common,
    super.private = false,
  });
  final bool common;
}

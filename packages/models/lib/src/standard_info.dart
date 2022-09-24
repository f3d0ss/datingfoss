import 'package:models/src/signup/private_data.dart';

class StandardInfo {
  const StandardInfo({
    required this.textInfo,
    required this.dateInfo,
    required this.boolInfo,
  });

  final Map<String, PrivateData<String>> textInfo;
  final Map<String, PrivateData<DateTime>> dateInfo;
  final Map<String, PrivateData<bool>> boolInfo;
}

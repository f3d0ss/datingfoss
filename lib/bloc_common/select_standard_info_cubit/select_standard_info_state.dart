part of 'select_standard_info_cubit.dart';

class SelectStandardInfoState extends Equatable {
  const SelectStandardInfoState({
    this.textInfo = const {},
    this.dateInfo = const {},
    this.boolInfo = const {},
    this.status = InfoStatus.invalid,
  });

  final Map<String, TextInfo> textInfo;
  final Map<String, DateInfo> dateInfo;
  final Map<String, BoolInfo> boolInfo;
  final InfoStatus status;

  SelectStandardInfoState copyWith({
    InfoStatus? status,
    Map<String, TextInfo>? textInfo,
    Map<String, DateInfo>? dateInfo,
    Map<String, BoolInfo>? boolInfo,
  }) {
    return SelectStandardInfoState(
      status: status ?? this.status,
      textInfo: textInfo ?? this.textInfo,
      dateInfo: dateInfo ?? this.dateInfo,
      boolInfo: boolInfo ?? this.boolInfo,
    );
  }

  @override
  List<Object> get props => [textInfo, dateInfo, boolInfo, status];
}

enum InfoStatus {
  valid,
  invalid,
  submitted,
}

class Info {
  static InfoStatus validate(List<InputInfo<dynamic>> textInfo) {
    return textInfo.every((element) => !element.pure && element.error == null)
        ? InfoStatus.valid
        : InfoStatus.invalid;
  }
}

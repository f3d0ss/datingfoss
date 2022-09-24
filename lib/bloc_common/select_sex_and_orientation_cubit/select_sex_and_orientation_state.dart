part of 'select_sex_and_orientation_cubit.dart';

class SelectSexAndOrientationState extends Equatable {
  const SelectSexAndOrientationState({
    this.sex = const PrivateData(0.5),
    this.searching = const PrivateData(RangeValues(0, 1)),
    this.status = Status.initial,
  });

  final PrivateData<double> sex;
  final PrivateData<RangeValues> searching;
  final Status status;

  SelectSexAndOrientationState copyWith({
    PrivateData<double>? sex,
    PrivateData<RangeValues>? searching,
    Status? status,
  }) {
    return SelectSexAndOrientationState(
      sex: sex ?? this.sex,
      searching: searching ?? this.searching,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [sex, searching];
}

enum Status {
  initial,
  edited,
}

import 'package:equatable/equatable.dart';

class RangeValues extends Equatable {
  const RangeValues(this.start, this.end);

  factory RangeValues.fromJson(Map<String, dynamic> json) =>
      RangeValues(json['start'] as double, json['end'] as double);

  final double start;
  final double end;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'start': start, 'end': end};

  @override
  List<Object?> get props => [start, end];
}

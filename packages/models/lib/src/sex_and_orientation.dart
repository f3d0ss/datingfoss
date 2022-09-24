import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class SexAndOrientation extends Equatable {
  const SexAndOrientation({required this.searching, required this.sex});

  final PrivateData<RangeValues> searching;
  final PrivateData<double> sex;

  @override
  List<Object?> get props => [searching, sex];
}

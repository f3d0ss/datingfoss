import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'select_sex_and_orientation_state.dart';

class SelectSexAndOrientationCubit extends Cubit<SelectSexAndOrientationState> {
  SelectSexAndOrientationCubit({
    PrivateData<double>? initialSex,
    PrivateData<RangeValues>? initialSearching,
  }) : super(
          initialSex != null && initialSearching != null
              ? SelectSexAndOrientationState(
                  searching: initialSearching,
                  sex: initialSex,
                )
              : const SelectSexAndOrientationState(),
        );

  void sexChanged({double? sex, bool? private}) {
    emit(
      state.copyWith(
        sex: state.sex.copyWith(
          data: sex,
          private: private,
        ),
        status: Status.edited,
      ),
    );
  }

  void searchingChanged({RangeValues? searching, bool? private}) {
    emit(
      state.copyWith(
        searching: state.searching.copyWith(
          data: searching,
          private: private,
        ),
        status: Status.edited,
      ),
    );
  }
}

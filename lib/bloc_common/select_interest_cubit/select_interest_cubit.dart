import 'package:bloc/bloc.dart';
import 'package:datingfoss/utils/string_extension.dart';
import 'package:equatable/equatable.dart';

part 'select_interest_state.dart';

class SelectInterestCubit extends Cubit<SelectInterestState> {
  SelectInterestCubit({
    required bool private,
    List<String> initialInterests = const [],
  }) : super(
          SelectInterestState(
            private: private,
            initInterests: initialInterests
                .map(
                  (e) =>
                      Interest(interestName: e.capitalize(), isSelected: true),
                )
                .toList(),
          ),
        );

  void selectedInterest(String interestName) {
    final interestIndex = state.interests
        .indexWhere((element) => element.interestName == interestName);
    final newInterests = [...state.interests];
    final toggleInterest = newInterests[interestIndex];
    newInterests[interestIndex] =
        toggleInterest.copyWith(isSelected: !toggleInterest.isSelected);
    emit(state.copyWith(interests: newInterests));
  }

  void addedNewInterest(String interestName) {
    if (state.interests
        .any((interest) => interest.interestName == interestName)) {
      selectedInterest(interestName);
    } else {
      final interest = Interest(interestName: interestName, isSelected: true);
      final newInterests = [...state.interests, interest];
      emit(state.copyWith(interests: newInterests));
    }
  }
}

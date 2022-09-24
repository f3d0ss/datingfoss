import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:datingfoss/profile/edit_interest/cubit/edit_interest_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('select interest', () {
    test('Initial sate should be SelectInterestState', () {
      final cubit = EditInterestCubit(private: false);
      expect(cubit.state, SelectInterestState(private: false));
    });

    blocTest<EditInterestCubit, SelectInterestState>(
      'selectInterest should correctly toggle an interest',
      build: () => EditInterestCubit(private: false),
      act: (cubit) =>
          cubit.selectedInterest(cubit.state.interests.first.interestName),
      verify: (cubit) {
        expect(cubit.state.interests.first.isSelected, true);
      },
    );

    blocTest<EditInterestCubit, SelectInterestState>(
      'addedNewInterest should correctly add a new interest',
      build: () => EditInterestCubit(private: false),
      act: (cubit) => cubit.addedNewInterest('notExistentInterest'),
      verify: (cubit) {
        expect(
          cubit.state.interests
              .any((element) => element.interestName == 'notExistentInterest'),
          true,
        );
      },
    );

    blocTest<EditInterestCubit, SelectInterestState>(
      'addedNewInterest should toggle an interest if name already exists',
      build: () => EditInterestCubit(private: false),
      act: (cubit) =>
          cubit.addedNewInterest(cubit.state.interests.first.interestName),
      verify: (cubit) {
        expect(
          cubit.state.interests.first.isSelected,
          true,
        );
      },
    );
  });
}

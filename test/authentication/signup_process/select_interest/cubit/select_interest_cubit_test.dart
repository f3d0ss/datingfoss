import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_interest/cubit/add_interest_cubit.dart';
import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('select interest', () {
    test('Initial sate should be SelectInterestState', () {
      final cubit = AddInterestCubit(private: false);
      expect(cubit.state, SelectInterestState(private: false));
    });

    blocTest<AddInterestCubit, SelectInterestState>(
      'selectInterest should correctly toggle an interest',
      build: () => AddInterestCubit(private: false),
      act: (cubit) =>
          cubit.selectedInterest(cubit.state.interests.first.interestName),
      verify: (cubit) {
        expect(cubit.state.interests.first.isSelected, true);
      },
    );

    blocTest<AddInterestCubit, SelectInterestState>(
      'addedNewInterest should correctly add a new interest',
      build: () => AddInterestCubit(private: false),
      act: (cubit) => cubit.addedNewInterest('notExistentInterest'),
      verify: (cubit) {
        expect(
          cubit.state.interests
              .any((element) => element.interestName == 'notExistentInterest'),
          true,
        );
      },
    );

    blocTest<AddInterestCubit, SelectInterestState>(
      'addedNewInterest should toggle an interest if name already exists',
      build: () => AddInterestCubit(private: false),
      act: (cubit) =>
          cubit.addedNewInterest(cubit.state.interests.first.interestName),
      verify: (cubit) {
        expect(
          cubit.state.interests.first.isSelected,
          true,
        );
      },
    );

    blocTest<AddInterestCubit, SelectInterestState>(
      'trySubmit should emit a warning if there are not interests selected',
      build: () => AddInterestCubit(private: false),
      act: (cubit) => cubit.trySubmit(),
      verify: (cubit) {
        expect(
          cubit.state.status,
          InterestStatus.warning,
        );
      },
    );

    blocTest<AddInterestCubit, SelectInterestState>(
      '''trySubmit should set status to submitted if at least one 
      interest is selected''',
      seed: () {
        final state = SelectInterestState(private: true);
        final newInterests = List<Interest>.from(state.interests);
        newInterests[0] = newInterests.first.copyWith(isSelected: true);
        return state.copyWith(interests: newInterests);
      },
      build: () => AddInterestCubit(private: false),
      act: (cubit) => cubit.trySubmit(),
      verify: (cubit) {
        expect(
          cubit.state.status,
          InterestStatus.submitted,
        );
      },
    );

    group('sgnuUpFlow test', () {
      var signUpFlow = FlowController<SignupFlowState>(const SignupFlowState());

      blocTest<AddInterestCubit, SelectInterestState>(
        'submit should set signup flow status to selectingPublicBio on private',
        seed: () {
          final state = SelectInterestState(private: true);
          final newInterests = List<Interest>.from(state.interests);
          newInterests[0] = newInterests.first.copyWith(isSelected: true);
          return state.copyWith(interests: newInterests);
        },
        build: () => AddInterestCubit(private: false),
        act: (cubit) => cubit.submitted(
          signUpFlow = FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(
            signUpFlow.state.signupStatus,
            SignupStatus.selectingPublicBio,
          );
        },
      );

      blocTest<AddInterestCubit, SelectInterestState>(
        '''submit should set signup flow status to selectingPrivateInterests 
        on private''',
        seed: () {
          final state = SelectInterestState(private: false);
          final newInterests = List<Interest>.from(state.interests);
          newInterests[0] = newInterests.first.copyWith(isSelected: true);
          return state.copyWith(interests: newInterests);
        },
        build: () => AddInterestCubit(private: false),
        act: (cubit) => cubit.submitted(
          signUpFlow = FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(
            signUpFlow.state.signupStatus,
            SignupStatus.selectingPrivateInterests,
          );
        },
      );

      blocTest<AddInterestCubit, SelectInterestState>(
        'forceSubit should also with warning',
        seed: () {
          final state = SelectInterestState(private: false);
          final newInterests = List<Interest>.from(state.interests);
          newInterests[0] = newInterests.first.copyWith(isSelected: true);
          return state.copyWith(
            interests: newInterests,
            status: InterestStatus.warning,
          );
        },
        build: () => AddInterestCubit(private: false),
        act: (cubit) => cubit.forceSubmit(
          signUpFlow = FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(
            cubit.state.status,
            InterestStatus.submitted,
          );
        },
      );

      blocTest<AddInterestCubit, SelectInterestState>(
        'dismissWarning dismiss warning and set status to valid',
        seed: () {
          final state = SelectInterestState(private: false);
          final newInterests = List<Interest>.from(state.interests);
          newInterests[0] = newInterests.first.copyWith(isSelected: true);
          return state.copyWith(
            interests: newInterests,
            status: InterestStatus.warning,
          );
        },
        build: () => AddInterestCubit(private: false),
        act: (cubit) => cubit.dismissWarning(),
        verify: (cubit) {
          expect(
            cubit.state.status,
            InterestStatus.valid,
          );
        },
      );
    });
  });
}

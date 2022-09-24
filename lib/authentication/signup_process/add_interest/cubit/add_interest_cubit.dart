import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

class AddInterestCubit extends SelectInterestCubit {
  AddInterestCubit({required super.private});

  void trySubmit() {
    if (state.interests.every((interest) => interest.isSelected == false)) {
      emit(state.copyWith(status: InterestStatus.warning));
    } else {
      emit(state.copyWith(status: InterestStatus.submitted));
    }
  }

  void submitted(FlowController<SignupFlowState> flow) {
    if (state.interests.every((interest) => interest.isSelected == false)) {
      emit(state.copyWith(status: InterestStatus.warning));
    } else {
      emit(state.copyWith(status: InterestStatus.valid));
      _updateFlow(flow);
    }
  }

  void forceSubmit(FlowController<SignupFlowState> flow) {
    if (state.status == InterestStatus.warning) {
      emit(state.copyWith(status: InterestStatus.submitted));
      _updateFlow(flow);
    }
  }

  void dismissWarning() {
    if (state.status == InterestStatus.warning) {
      emit(state.copyWith(status: InterestStatus.valid));
    }
  }

  void _updateFlow(FlowController<SignupFlowState> flow) {
    if (state.private) {
      flow.update(
        (flowState) => flowState.copyWith(
          signupStatus: SignupStatus.selectingPublicBio,
          privateInsterests: state.interests
              .where((interest) => interest.isSelected == true)
              .map((interest) => interest.interestName)
              .toList(),
        ),
      );
    } else {
      flow.update(
        (flowState) => flowState.copyWith(
          signupStatus: SignupStatus.selectingPrivateInterests,
          interests: state.interests
              .where((interest) => interest.isSelected == true)
              .map((interest) => interest.interestName)
              .toList(),
        ),
      );
    }
  }
}

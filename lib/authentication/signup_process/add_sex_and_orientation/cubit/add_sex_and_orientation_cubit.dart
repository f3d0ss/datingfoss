import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

class AddSexAndOrientationCubit extends SelectSexAndOrientationCubit {
  AddSexAndOrientationCubit();

  void submitted(FlowController<SignupFlowState> flowController) {
    flowController.update(
      (flowState) => flowState.copyWith(
        signupStatus: SignupStatus.selectingStandardInfo,
        sex: state.sex,
        searching: state.searching,
      ),
    );
  }
}

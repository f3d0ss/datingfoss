import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';

import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

class AddStandardInfoCubit extends SelectStandardInfoCubit {
  AddStandardInfoCubit(super.textInfo, super.dateInfo, super.boolInfo);

  void submitted(FlowController<SignupFlowState> flow) {
    if (state.status == InfoStatus.valid) {
      final dateInfo = {...state.dateInfo}..removeWhere(
          (key, value) => value.data.data == null,
        );
      flow.update(
        (flowState) => flowState.copyWith(
          signupStatus: SignupStatus.selectingPublicInterests,
          textInfo:
              state.textInfo.map((key, value) => MapEntry(key, value.data)),
          dateInfo: dateInfo.map(
            (key, value) => MapEntry(
              key,
              PrivateData<DateTime>(
                value.data.data!,
                private: value.data.private,
              ),
            ),
          ),
          boolInfo:
              state.boolInfo.map((key, value) => MapEntry(key, value.data)),
        ),
      );
    }
  }
}

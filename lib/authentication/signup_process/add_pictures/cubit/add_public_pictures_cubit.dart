import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_pictures_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

class AddPublicPicturesCubit extends AddPicturesCubit {
  @override
  void updateFlow(FlowController<SignupFlowState> flow) {
    flow.update(
      (flowState) => flowState.copyWith(
        signupStatus: SignupStatus.selectingPrivatePictures,
        pictures: state.pictures,
      ),
    );
  }
}

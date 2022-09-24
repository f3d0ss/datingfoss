import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_pictures_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

class AddPrivatePicturesCubit extends AddPicturesCubit {
  @override
  void updateFlow(FlowController<SignupFlowState> flow) {
    flow.complete(
      (flowState) => flowState.copyWith(
        signupStatus: SignupStatus.completed,
        privatePictures: state.pictures,
      ),
    );
  }
}

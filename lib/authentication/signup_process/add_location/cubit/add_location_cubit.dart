import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class AddLocationCubit extends SelectLocationCubit {
  AddLocationCubit();

  void confirmedLocation(FlowController<SignupFlowState> flow) {
    if (state is SelectLocationWithCoordinates) {
      final latitude = (state as SelectLocationWithCoordinates).latitude;
      final longitude = (state as SelectLocationWithCoordinates).longitude;
      final private = (state as SelectLocationWithCoordinates).private;
      flow.update(
        (flowState) => flowState.copyWith(
          signupStatus: SignupStatus.selectingSexAndOrientation,
          location: PrivateData<LatLng>(
            LatLng(latitude, longitude),
            private: private,
          ),
        ),
      );
    } else {
      flow.update(
        (flowState) => flowState.copyWith(
          signupStatus: SignupStatus.selectingSexAndOrientation,
        ),
      );
    }
  }
}

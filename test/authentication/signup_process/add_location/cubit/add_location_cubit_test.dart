import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  var flow = FlowController<SignupFlowState>(const SignupFlowState());
  group('signup', () {
    test('Initial state should be AddLocationInitial', () {
      final addLocationCubit = AddLocationCubit();
      expect(addLocationCubit.state, const SelectLocationInitial());
    });

    // final geolocatorMock = MockGeolocatorPlatform();
    // setUp(() {
    //   GeolocatorPlatform.instance = geolocatorMock;
    // });

    // test(
    //     '''getGPS should emit AddLocationErrorGPS if gps locationService
    // is disabled''',
    //     () async {
    //   when(geolocatorMock.isLocationServiceEnabled)
    //       .thenAnswer((_) => Future.value(false));

    //   final addLocationCubit = AddLocationCubit();
    //   await addLocationCubit.getGPS();
    //   var state = addLocationCubit.state;
    // });

    test('getGPS should emit AddLocationFromTap if tapped location is called',
        () {
      final addLocationCubit = AddLocationCubit()..tappedLocation(22, 22);
      expect(
        addLocationCubit.state,
        const SelectLocationFromTap(
          latitude: 22,
          longitude: 22,
          private: false,
        ),
      );
    });

    blocTest<AddLocationCubit, SelectLocationState>(
      '''signup flow state should be selectingSexAndOrientation after
       confirmedLocation is called''',
      build: AddLocationCubit.new,
      act: (cubit) => cubit.confirmedLocation(
        flow = FlowController<SignupFlowState>(const SignupFlowState()),
      ),
      verify: (_) {
        expect(
          flow.state.signupStatus,
          SignupStatus.selectingSexAndOrientation,
        );
      },
    );

    blocTest<AddLocationCubit, SelectLocationState>(
      '''signup flow state should contains latitude and longitude 
      after confirmedLocation''',
      seed: () => const SelectLocationWithCoordinates(
        latitude: 22,
        longitude: 22,
        private: false,
      ),
      build: AddLocationCubit.new,
      act: (cubit) => cubit.confirmedLocation(
        flow = FlowController<SignupFlowState>(const SignupFlowState()),
      ),
      verify: (_) {
        final location = flow.state.localUser.location!;
        expect(location.data.latitude, 22);
        expect(location.data.longitude, 22);
      },
    );
  });
}

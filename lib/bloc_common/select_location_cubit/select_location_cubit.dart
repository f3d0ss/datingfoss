import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'select_location_state.dart';

class SelectLocationCubit extends Cubit<SelectLocationState> {
  SelectLocationCubit({
    double? latitude,
    double? longitude,
    bool? private,
  }) : super(
          latitude != null && longitude != null && private != null
              ? SelectLocationWithCoordinates(
                  latitude: latitude,
                  longitude: longitude,
                  private: private,
                )
              : const SelectLocationInitial(),
        );

  Future<void> getGPS() async /*not sure if async is right*/ {
    late bool private;
    if (state is SelectLocationWithCoordinates) {
      private = (state as SelectLocationWithCoordinates).private;
    } else {
      private = false;
    }
    emit(const SelectLocationInProgeressGPS());

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      emit(const SelectLocationErrorGPS('Location services are disabled.'));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        emit(const SelectLocationErrorGPS('Location permissions are denied'));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      emit(
        const SelectLocationErrorGPS(
          '''
            Location permissions are permanently denied,
            we cannot request permissions.''',
        ),
      );
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final currentPosition = await Geolocator.getCurrentPosition();
    emit(
      SelectLocationFromGPS(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        private: private,
      ),
    );
  }

  void tappedLocation(double latitude, double longitude) {
    late bool private;
    if (state is SelectLocationWithCoordinates) {
      private = (state as SelectLocationWithCoordinates).private;
    } else {
      private = false;
    }
    emit(
      SelectLocationFromTap(
        latitude: latitude,
        longitude: longitude,
        private: private,
      ),
    );
  }

  void setPrivate({required bool private}) {
    if (state is SelectLocationWithCoordinates) {
      final oldState = state as SelectLocationWithCoordinates;
      emit(
        SelectLocationFromTap(
          latitude: oldState.latitude,
          longitude: oldState.longitude,
          private: private,
        ),
      );
    }
  }
}

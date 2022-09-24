import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:datingfoss/profile/edit_location/cubit/edit_location_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

class MockGeolocatorPlatform extends Mock implements GeolocatorPlatform {}

void main() {
  group('signup', () {
    const latitude = 0.0;
    const longitude = 0.0;
    test('Initial state should be EditLocationWithCoordinates', () {
      final editLocationCubit = EditLocationCubit(
        latitude: latitude,
        longitude: longitude,
        private: false,
      );
      expect(
        editLocationCubit.state,
        const SelectLocationWithCoordinates(
          latitude: latitude,
          longitude: longitude,
          private: false,
        ),
      );
    });

    test('getGPS should emit AddLocationFromTap if tapped location is called',
        () {
      final editLocationCubit =
          EditLocationCubit(latitude: 0, longitude: 0, private: false)
            ..tappedLocation(22, 22);
      expect(
        editLocationCubit.state,
        const SelectLocationFromTap(
          latitude: 22,
          longitude: 22,
          private: false,
        ),
      );
    });

    test('set private emit new state with private status', () {
      final editLocationCubit = EditLocationCubit(
        latitude: latitude,
        longitude: longitude,
        private: false,
      )..setPrivate(private: true);
      expect(
        editLocationCubit.state,
        const SelectLocationFromTap(
          latitude: latitude,
          longitude: longitude,
          private: true,
        ),
      );
    });
  });
}

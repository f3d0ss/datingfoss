import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

Position get mockPosition => Position(
      latitude: 52.561270,
      longitude: 5.639382,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        500,
        isUtc: true,
      ),
      altitude: 3000,
      accuracy: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );

class MockGeolocatorPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {
  MockGeolocatorPlatform({
    this.noLocationService = false,
    this.permissionDenied = false,
    this.permissionDeniedForever = false,
  });
  final bool noLocationService;
  final bool permissionDenied;
  final bool permissionDeniedForever;
  @override
  Future<bool> isLocationServiceEnabled() => Future.value(!noLocationService);
  @override
  Future<LocationPermission> checkPermission() => Future.value(
        permissionDeniedForever
            ? LocationPermission.deniedForever
            : LocationPermission.denied,
      );
  @override
  Future<LocationPermission> requestPermission() => Future.value(
        permissionDenied
            ? LocationPermission.denied
            : LocationPermission.whileInUse,
      );
  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);
}

void main() {
  group('SelectLocationCubit', () {
    group('if location service not enabled', () {
      setUp(() {
        GeolocatorPlatform.instance =
            MockGeolocatorPlatform(noLocationService: true);
      });
      blocTest<SelectLocationCubit, SelectLocationState>(
        'getGPS emit error state',
        build: SelectLocationCubit.new,
        act: (cubit) => cubit.getGPS(),
        expect: () => [
          const SelectLocationInProgeressGPS(),
          const SelectLocationErrorGPS('Location services are disabled.')
        ],
      );
    });
    group('if location permission are denied', () {
      setUp(() {
        GeolocatorPlatform.instance =
            MockGeolocatorPlatform(permissionDenied: true);
      });
      blocTest<SelectLocationCubit, SelectLocationState>(
        'getGPS emit error state',
        build: () =>
            SelectLocationCubit(latitude: 0, longitude: 0, private: true),
        act: (cubit) => cubit.getGPS(),
        expect: () => [
          const SelectLocationInProgeressGPS(),
          const SelectLocationErrorGPS('Location permissions are denied')
        ],
      );
    });

    group('if location permission are denied forever', () {
      setUp(() {
        GeolocatorPlatform.instance =
            MockGeolocatorPlatform(permissionDeniedForever: true);
      });
      blocTest<SelectLocationCubit, SelectLocationState>(
        'getGPS emit error state',
        build: SelectLocationCubit.new,
        act: (cubit) => cubit.getGPS(),
        expect: () => [
          const SelectLocationInProgeressGPS(),
          const SelectLocationErrorGPS(
            '''
            Location permissions are permanently denied,
            we cannot request permissions.''',
          )
        ],
      );
    });

    group('if location permission are granted', () {
      setUp(() {
        GeolocatorPlatform.instance = MockGeolocatorPlatform();
      });
      blocTest<SelectLocationCubit, SelectLocationState>(
        'getGPS emit error state',
        build: SelectLocationCubit.new,
        act: (cubit) => cubit.getGPS(),
        expect: () => [
          const SelectLocationInProgeressGPS(),
          SelectLocationFromGPS(
            latitude: mockPosition.latitude,
            longitude: mockPosition.longitude,
            private: false,
          )
        ],
      );
    });
  });
  group('SelectLocationState', () {
    test('can compare', () {
      // ignore: prefer_const_constructors
      expect(SelectLocationInitial(), SelectLocationInitial());
    });
  });
}

part of 'select_location_cubit.dart';

@immutable
abstract class SelectLocationState extends Equatable {
  const SelectLocationState();
}

class SelectLocationInitial extends SelectLocationState {
  const SelectLocationInitial();

  @override
  List<Object?> get props => [];
}

class SelectLocationInProgeressGPS extends SelectLocationState {
  const SelectLocationInProgeressGPS();
  @override
  List<Object?> get props => [];
}

class SelectLocationErrorGPS extends SelectLocationState {
  const SelectLocationErrorGPS(this.error);
  final String error;
  @override
  List<Object?> get props => [error];
}

class SelectLocationWithCoordinates extends SelectLocationState {
  const SelectLocationWithCoordinates({
    required this.latitude,
    required this.longitude,
    required this.private,
  });

  final double latitude;
  final double longitude;
  final bool private;

  @override
  List<Object?> get props => [latitude, longitude, private];
}

class SelectLocationFromGPS extends SelectLocationWithCoordinates {
  const SelectLocationFromGPS({
    required super.latitude,
    required super.longitude,
    required super.private,
  });
  @override
  List<Object?> get props => [latitude, longitude, private];
}

class SelectLocationFromTap extends SelectLocationWithCoordinates {
  const SelectLocationFromTap({
    required super.latitude,
    required super.longitude,
    required super.private,
  });
  @override
  List<Object?> get props => [latitude, longitude, private];
}

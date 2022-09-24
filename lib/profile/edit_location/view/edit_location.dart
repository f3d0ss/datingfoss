import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:datingfoss/profile/edit_location/cubit/edit_location_cubit.dart';
import 'package:datingfoss/widgets/select_location_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class EditLocation extends StatelessWidget {
  const EditLocation({required this.location, super.key});

  static Route<PrivateData<LatLng>> route({
    required PrivateData<LatLng> location,
  }) {
    return MaterialPageRoute(
      builder: (_) => EditLocation(location: location),
    );
  }

  final PrivateData<LatLng> location;

  @override
  Widget build(BuildContext context) {
    final editLocationCubit = EditLocationCubit(
      latitude: location.data.latitude,
      longitude: location.data.longitude,
      private: location.private,
    );
    return SelectLocationMap(
      selectLocationCubit: editLocationCubit,
      doneButton: BlocBuilder(
        bloc: editLocationCubit,
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.save),
            onPressed: (state is SelectLocationWithCoordinates)
                ? () {
                    Navigator.of(context).pop(
                      PrivateData(
                        LatLng(state.latitude, state.longitude),
                        private: state.private,
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}

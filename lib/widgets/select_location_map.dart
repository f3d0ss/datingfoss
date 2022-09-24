import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectLocationMap extends StatelessWidget {
  const SelectLocationMap({
    super.key,
    required this.selectLocationCubit,
    required this.doneButton,
  });

  final SelectLocationCubit selectLocationCubit;
  final Widget doneButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          BlocBuilder<SelectLocationCubit, SelectLocationState>(
            bloc: selectLocationCubit,
            builder: (context, state) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (state is SelectLocationWithCoordinates) {
                        selectLocationCubit.setPrivate(private: !state.private);
                      }
                    },
                    icon: (state is SelectLocationWithCoordinates) &&
                            state.private
                        ? const Icon(Icons.lock)
                        : const Icon(Icons.lock_open),
                  ),
                  doneButton,
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SelectLocationCubit, SelectLocationState>(
        bloc: selectLocationCubit,
        builder: (context, state) {
          return FlutterMap(
            key: (state is SelectLocationFromGPS)
                ? Key('${state.latitude}${state.longitude}')
                : const Key(''),
            options: MapOptions(
              center: (state is SelectLocationWithCoordinates)
                  ? LatLng(state.latitude, state.longitude)
                  : LatLng(45.478157, 9.22754),
              zoom: 16,
              onTap: (_, latlng) {
                selectLocationCubit.tappedLocation(
                  latlng.latitude,
                  latlng.longitude,
                );
              },
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  if (state is SelectLocationWithCoordinates)
                    Marker(
                      width: 64,
                      height: 128,
                      point: LatLng(state.latitude, state.longitude),
                      builder: (ctx) => Column(
                        children: const [
                          Icon(Icons.location_pin, color: Colors.red, size: 64)
                        ],
                      ),
                      rotate: true,
                    ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton:
          BlocBuilder<SelectLocationCubit, SelectLocationState>(
        bloc: selectLocationCubit,
        builder: (context, state) {
          return ElevatedButton(
            onPressed: (state is SelectLocationInProgeressGPS)
                ? null
                : selectLocationCubit.getGPS,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            child: (state is SelectLocationInProgeressGPS)
                ? const CircularProgressIndicator()
                : const Icon(Icons.place),
          );
        },
      ),
    );
  }
}

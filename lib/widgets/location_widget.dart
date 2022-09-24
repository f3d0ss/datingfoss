import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.location,
  });

  final PrivateData<LatLng> location;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 200,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: FlutterMap(
              key: Key(location.data.toString()),
              options: MapOptions(
                center: location.data,
                zoom: 8,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 64,
                      height: 64,
                      point: location.data,
                      builder: (ctx) => Column(
                        children: const [
                          Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 32,
                          )
                        ],
                      ),
                      rotate: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Icon(
            location.private ? Icons.lock : Icons.lock_open,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

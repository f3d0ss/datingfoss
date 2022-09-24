import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/edit_location/view/edit_location.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class EditableLocation extends StatelessWidget {
  const EditableLocation({
    super.key,
    required this.child,
    required this.location,
  });

  final Widget child;
  final PrivateData<LatLng>? location;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final editedLocation =
            await Navigator.of(context).push<PrivateData<LatLng>>(
          EditLocation.route(
            location: location ?? PrivateData<LatLng>(LatLng(0, 0)),
          ),
        );
        if (editedLocation != null) {
          context.read<ProfileBloc>().add(
                LocationEdited(
                  latitude: editedLocation.data.latitude,
                  longitude: editedLocation.data.longitude,
                  private: editedLocation.private,
                ),
              );
        }
      },
      child: child,
    );
  }
}

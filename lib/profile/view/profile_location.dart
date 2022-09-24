import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_location.dart';
import 'package:datingfoss/profile/view/profile_info_section.dart';
import 'package:datingfoss/widgets/location_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileLocation extends StatelessWidget {
  const ProfileLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final location = state.user.location;

        return Column(
          children: [
            EditableLocation(
              location: location,
              child: ProfileInfoSection(
                content: location != null
                    ? LocationWidget(location: location)
                    : Container(),
                title: 'Location',
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_sex_and_orientation.dart';
import 'package:datingfoss/profile/view/profile_info_section.dart';
import 'package:datingfoss/utils/range_values_extension.dart';
import 'package:datingfoss/widgets/privatizable_searching_slider.dart';
import 'package:datingfoss/widgets/privatizable_sex_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart' as models;

class ProfileSexAndOrientation extends StatelessWidget {
  const ProfileSexAndOrientation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final sex = state.user.sex;
        final searching = state.user.searching;

        return Column(
          children: [
            EditableSexAndOrientation(
              sex: sex,
              searching: searching,
              child: ProfileInfoSection(
                content: PrivatizableSexSlider(initialValue: sex!),
                title: 'Sex',
              ),
            ),
            EditableSexAndOrientation(
              sex: sex,
              searching: searching,
              child: ProfileInfoSection(
                content: PrivatizableSearchingSlider(
                  initialValue: models.PrivateData(
                    searching!.data.materialRangeValues,
                    private: searching.private,
                  ),
                ),
                title: 'Searching',
              ),
            ),
          ],
        );
      },
    );
  }
}

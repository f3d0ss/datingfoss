import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_standard_info.dart';
import 'package:datingfoss/profile/view/profile_info_section.dart';
import 'package:datingfoss/widgets/bool_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBoolInfo extends StatelessWidget {
  const ProfileBoolInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return EditableStandardInfo(
          child: ProfileInfoSection(
            content: Column(
              children: state.user.boolInfo
                  .map<String, Widget>(
                    (key, value) => MapEntry(
                      key,
                      BoolInfoRow(
                        id: key,
                        data: value,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            title: 'Boolean info',
          ),
        );
      },
    );
  }
}

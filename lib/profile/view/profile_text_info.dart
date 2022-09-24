import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_standard_info.dart';
import 'package:datingfoss/profile/view/profile_info_section.dart';
import 'package:datingfoss/widgets/text_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTextInfo extends StatelessWidget {
  const ProfileTextInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return EditableStandardInfo(
          child: ProfileInfoSection(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: state.user.textInfo
                  .map<String, Widget>(
                    (key, value) => MapEntry(
                      key,
                      TextInfoRow(
                        id: key,
                        data: value,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            title: 'Text info',
          ),
        );
      },
    );
  }
}

import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/edit_standard_info/view/edit_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class EditableStandardInfo extends StatelessWidget {
  const EditableStandardInfo({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            final editedStandardInfo =
                await Navigator.of(context).push<StandardInfo>(
              EditInfoScreen.route(
                StandardInfo(
                  textInfo: state.user.textInfo,
                  dateInfo: state.user.dateInfo,
                  boolInfo: state.user.boolInfo,
                ),
              ),
            );
            if (editedStandardInfo != null) {
              context
                  .read<ProfileBloc>()
                  .add(StandardInfoEdited(editedStandardInfo));
            }
          },
          child: child,
        );
      },
    );
  }
}

import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/edit_sex_and_orientation/view/edit_sex_and_orientation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class EditableSexAndOrientation extends StatelessWidget {
  const EditableSexAndOrientation({
    super.key,
    required this.child,
    required this.sex,
    required this.searching,
  });

  final Widget child;
  final PrivateData<double>? sex;
  final PrivateData<RangeValues>? searching;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final editedSexAndOrientation =
            await Navigator.of(context).push<SexAndOrientation>(
          EditSexAndOrientation.route(searching: searching!, sex: sex!),
        );
        if (editedSexAndOrientation != null) {
          context.read<ProfileBloc>().add(
                SexAndOrientationEdited(
                  searching: editedSexAndOrientation.searching,
                  sex: editedSexAndOrientation.sex,
                ),
              );
        }
      },
      child: child,
    );
  }
}

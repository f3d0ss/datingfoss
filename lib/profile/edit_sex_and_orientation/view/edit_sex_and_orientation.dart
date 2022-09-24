import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/profile/edit_sex_and_orientation/cubit/edit_sex_and_orientation_cubit.dart';
import 'package:datingfoss/widgets/select_sex_and_orientation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart' as models;

class EditSexAndOrientation extends StatelessWidget {
  const EditSexAndOrientation({
    super.key,
    required this.initialSex,
    required this.initialSearching,
  });

  static Route<models.SexAndOrientation> route({
    required models.PrivateData<double> sex,
    required models.PrivateData<models.RangeValues> searching,
  }) {
    return MaterialPageRoute(
      builder: (_) => EditSexAndOrientation(
        initialSex: sex,
        initialSearching: searching,
      ),
    );
  }

  final models.PrivateData<double> initialSex;
  final models.PrivateData<models.RangeValues> initialSearching;

  @override
  Widget build(BuildContext context) {
    final editSexAndOrientation = EditSexAndOrientationCubit(
      initialSearching: initialSearching,
      initialSex: initialSex,
    );
    return SelectSexAndOrientationScreen(
      selectSexAndOrientationCubit: editSexAndOrientation,
      appBarButton:
          BlocBuilder<EditSexAndOrientationCubit, SelectSexAndOrientationState>(
        bloc: editSexAndOrientation,
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.save),
            onPressed: state.status == Status.edited
                ? () => Navigator.pop<models.SexAndOrientation>(
                      context,
                      models.SexAndOrientation(
                        sex: state.sex,
                        searching: state.searching,
                      ),
                    )
                : null,
          );
        },
      ),
    );
  }
}

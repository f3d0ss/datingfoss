import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/widgets/select_sex_and_orientation_screen.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart' as models;

class SelectSexAndOrientation extends StatelessWidget {
  const SelectSexAndOrientation({super.key});

  @override
  Widget build(BuildContext context) {
    final addSexAndOrientationCubit =
        context.buildCubit<AddSexAndOrientationCubit>();
    return SelectSexAndOrientationScreen(
      selectSexAndOrientationCubit: addSexAndOrientationCubit,
      submitButton: SubmitButton(
        onSubmit: () {
          addSexAndOrientationCubit
              .submitted(context.flow<models.SignupFlowState>());
        },
      ),
    );
  }
}

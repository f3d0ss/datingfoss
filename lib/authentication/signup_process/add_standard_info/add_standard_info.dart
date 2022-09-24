import 'package:datingfoss/authentication/signup_process/add_standard_info/cubit/add_standard_info_cubit.dart';

import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:datingfoss/widgets/select_standard_info_screen.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class AddInfoScreen extends StatelessWidget {
  const AddInfoScreen({super.key});

  List<String> get _initialTextInput => const [
        'Name',
        'Surname',
      ];

  List<String> get _initialDateInput => const [
        'BirthDate',
      ];

  List<String> get _initialBoolInput => const [
        'Smoker',
      ];

  @override
  Widget build(BuildContext context) {
    final addStandardInfoCubit = AddStandardInfoCubit(
      {
        for (var value in _initialTextInput)
          value: const TextInfo.pure(PrivateData<String>(''))
      },
      {
        for (var value in _initialDateInput)
          value: const DateInfo.dirty(PrivateData<DateTime?>(null))
      },
      {
        for (var value in _initialBoolInput)
          value: const BoolInfo(PrivateData<bool>(false))
      },
    );
    return SelectStandardInfoScreen(
      selectStandardInfoCubit: addStandardInfoCubit,
      submitButton: BlocBuilder<AddStandardInfoCubit, SelectStandardInfoState>(
        bloc: addStandardInfoCubit,
        buildWhen: (previousState, state) =>
            previousState.status != state.status,
        builder: (context, state) {
          return SubmitButton(
            onSubmit: state.status == InfoStatus.valid
                ? () => addStandardInfoCubit
                    .submitted(context.flow<SignupFlowState>())
                : null,
          );
        },
      ),
    );
  }
}

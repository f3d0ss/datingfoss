import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:datingfoss/widgets/select_location_map.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class AddLocationScreen extends StatelessWidget {
  AddLocationScreen({super.key, AddLocationCubit? addLocationCubit})
      : addLocationCubit = addLocationCubit ?? AddLocationCubit();

  final AddLocationCubit addLocationCubit;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SelectLocationMap(
      selectLocationCubit: addLocationCubit,
      doneButton: BlocBuilder(
        bloc: addLocationCubit,
        builder: (context, state) => IconButton(
          icon: Icon(
            state is SelectLocationInitial
                ? Icons.not_listed_location_outlined
                : Icons.done,
          ),
          onPressed: state is SelectLocationInitial
              ? onProcedeWithoutLocationPressed(context, addLocationCubit)
              : state is SelectLocationWithCoordinates
                  ? onConfirmLocationPressed(context, addLocationCubit)
                  : null,
        ),
      ),
    );
  }

  void Function() onProcedeWithoutLocationPressed(
    BuildContext context,
    AddLocationCubit addLocationCubit,
  ) =>
      () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Do not use Location'),
            content: const Text(
              '''
The Location is important to help you find match.
Are you sure you do not want to add your location?''',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No'),
              ),
            ],
          ),
        );
        if (confirmed != null && confirmed) {
          addLocationCubit.confirmedLocation(context.flow<SignupFlowState>());
        }
      };

  void Function() onConfirmLocationPressed(
    BuildContext context,
    AddLocationCubit addLocationCubit,
  ) =>
      () => addLocationCubit.confirmedLocation(context.flow<SignupFlowState>());
}

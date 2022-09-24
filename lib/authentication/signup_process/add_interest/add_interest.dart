import 'package:datingfoss/authentication/signup_process/add_interest/cubit/add_interest_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:datingfoss/widgets/select_interests_screen.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class AddInterest extends StatelessWidget {
  const AddInterest({required this.private, super.key});

  final bool private;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddInterestCubit(private: private),
      child: BlocListener<AddInterestCubit, SelectInterestState>(
        listener: (context, state) async {
          if (state.status == InterestStatus.warning) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Empty Interests'),
                content: const Text(
                  '''
Interests are important to help you find match.
Are you sure you do not want to add interests?''',
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
              context
                  .read<AddInterestCubit>()
                  .forceSubmit(context.flow<SignupFlowState>());
            } else {
              context.read<AddInterestCubit>().dismissWarning();
            }
          }
        },
        child: Scaffold(
          appBar: AppBarExtension(
            backButton: true,
            context: context,
            titleText: 'Your Interests',
            subtitleText: private ? 'Private' : 'Public',
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocBuilder<AddInterestCubit, SelectInterestState>(
                    builder: (context, state) {
                      return SelectInterests(
                        interests: state.interests,
                        onInterestSelected:
                            context.read<AddInterestCubit>().selectedInterest,
                        onNewInterestAdded:
                            context.read<AddInterestCubit>().addedNewInterest,
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (context) => SubmitButton(
                    onSubmit: () {
                      context
                          .read<AddInterestCubit>()
                          .submitted(context.flow<SignupFlowState>());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:datingfoss/profile/edit_interest/cubit/edit_interest_cubit.dart';
import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:datingfoss/widgets/select_interests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditInterestScreen extends StatelessWidget {
  const EditInterestScreen({
    required this.private,
    required this.initialInterests,
    super.key,
  });

  final bool private;
  final List<String> initialInterests;

  static Route<List<String>> route({
    required bool private,
    required List<String> initialInterests,
  }) {
    return MaterialPageRoute(
      builder: (_) => EditInterestScreen(
        private: private,
        initialInterests: initialInterests,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditInterestCubit(
        private: private,
        initialInterests: initialInterests,
      ),
      child: Scaffold(
        appBar: AppBarExtension(
          backButton: true,
          context: context,
          titleText: 'Your Interests',
          subtitleText: private ? 'Private' : 'Public',
          actionButton: BlocBuilder<EditInterestCubit, SelectInterestState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  final selectedInterests = state.interests
                    ..removeWhere((element) => !element.isSelected);
                  Navigator.pop<List<String>>(
                    context,
                    selectedInterests.map((e) => e.interestName).toList(),
                  );
                },
              );
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<EditInterestCubit, SelectInterestState>(
                  builder: (context, state) {
                    return SelectInterests(
                      interests: state.interests,
                      onInterestSelected:
                          context.read<EditInterestCubit>().selectedInterest,
                      onNewInterestAdded:
                          context.read<EditInterestCubit>().addedNewInterest,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

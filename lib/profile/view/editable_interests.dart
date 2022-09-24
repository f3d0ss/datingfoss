import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/edit_interest/view/edit_interest_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditableInterests extends StatelessWidget {
  const EditableInterests({
    super.key,
    required this.child,
    required this.private,
    required this.intialInterests,
  });

  final Widget child;
  final bool private;
  final List<String> intialInterests;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final editedInterests = await Navigator.of(context).push<List<String>>(
          EditInterestScreen.route(
            private: private,
            initialInterests: intialInterests,
          ),
        );
        if (editedInterests != null) {
          context.read<ProfileBloc>().add(
                InterestsEdited(interests: editedInterests, private: private),
              );
        }
      },
      child: child,
    );
  }
}

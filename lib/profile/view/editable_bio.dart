import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/edit_bio/view/edit_bio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditableBio extends StatelessWidget {
  const EditableBio({
    super.key,
    required this.child,
    required this.private,
    required this.bio,
  });

  final Widget child;
  final bool private;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        final editedBio = await Navigator.of(context).push<String>(
          EditBio.route(
            private: private,
            bio: bio,
          ),
        );
        if (editedBio != null) {
          context.read<ProfileBloc>().add(
                BioEdited(bio: editedBio, private: private),
              );
        }
      },
      child: child,
    );
  }
}

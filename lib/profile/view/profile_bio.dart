import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_bio.dart';
import 'package:datingfoss/profile/view/profile_info_section.dart';
import 'package:datingfoss/widgets/bio_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicProfileBio extends StatelessWidget {
  const PublicProfileBio({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final publicBio = state.user.publicInfo.bio;
        return EditableBio(
          bio: publicBio,
          private: false,
          child: ProfileInfoSection(
            content: BioWidget(bio: publicBio, private: false),
            title: 'Public Bio',
          ),
        );
      },
    );
  }
}

class PrivateProfileBio extends StatelessWidget {
  const PrivateProfileBio({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final privateBio = state.user.privateInfo.bio;
        return EditableBio(
          bio: privateBio ?? '',
          private: true,
          child: ProfileInfoSection(
            content:
                BioWidget(bio: privateBio ?? 'No Private Bio', private: true),
            title: 'Private Bio',
          ),
        );
      },
    );
  }
}

import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/logout_button.dart';
import 'package:datingfoss/profile/view/profile_bio.dart';
import 'package:datingfoss/profile/view/profile_bool_info.dart';
import 'package:datingfoss/profile/view/profile_date_info.dart';
import 'package:datingfoss/profile/view/profile_images.dart';
import 'package:datingfoss/profile/view/profile_interests.dart';
import 'package:datingfoss/profile/view/profile_location.dart';
import 'package:datingfoss/profile/view/profile_sex_and_orientation.dart';
import 'package:datingfoss/profile/view/profile_text_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final landscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        return BlocProvider(
          create: (context) => context.buildBloc<ProfileBloc>(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: landscape
                        ? const LandscapeProfileView()
                        : const PortraitProfileView(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: const LogoutButton(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LandscapeProfileView extends StatelessWidget {
  const LandscapeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PublicProfileImages(),
                    Divider(),
                  ],
                ),
              ),
              const VerticalDivider(indent: 10, endIndent: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PrivateProfileImages(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ProfileTextInfo(),
                    Divider(),
                  ],
                ),
              ),
              const VerticalDivider(indent: 10, endIndent: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ProfileSexAndOrientation(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ProfileBoolInfo(),
                    Divider(),
                  ],
                ),
              ),
              const VerticalDivider(indent: 10, endIndent: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ProfileDateInfo(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PublicProfileInterests(),
                    Divider(),
                  ],
                ),
              ),
              const VerticalDivider(indent: 10, endIndent: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PrivateProfileInterests(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PublicProfileBio(),
                    Divider(),
                  ],
                ),
              ),
              const VerticalDivider(indent: 10, endIndent: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    PrivateProfileBio(),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        const ProfileLocation(),
        const Divider(),
      ],
    );
  }
}

class PortraitProfileView extends StatelessWidget {
  const PortraitProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          PublicProfileImages(),
          Divider(),
          PrivateProfileImages(),
          Divider(),
          ProfileTextInfo(),
          Divider(),
          ProfileBoolInfo(),
          Divider(),
          ProfileDateInfo(),
          Divider(),
          PublicProfileInterests(),
          Divider(),
          PrivateProfileInterests(),
          Divider(),
          PublicProfileBio(),
          Divider(),
          PrivateProfileBio(),
          Divider(),
          ProfileSexAndOrientation(),
          Divider(),
          ProfileLocation(),
          Divider(),
        ],
      ),
    );
  }
}

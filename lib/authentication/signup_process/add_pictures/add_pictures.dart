import 'dart:io';
import 'dart:math';

import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:datingfoss/widgets/empty_picture_slot.dart';
import 'package:datingfoss/widgets/picture_preview.dart';
import 'package:datingfoss/widgets/selection_camera_gallery.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class AddPictures extends StatefulWidget {
  const AddPictures({required this.private, super.key});

  static const initialEmptySlots = 9;
  final bool private;

  @override
  State<AddPictures> createState() => _AddPicturesState();
}

class _AddPicturesState extends State<AddPictures> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.private
          ? context.buildCubit<AddPrivatePicturesCubit>()
          : context.buildCubit<AddPublicPicturesCubit>(),
      child: BlocListener<AddPicturesCubit, AddPicturesState>(
        listener: (context, state) async {
          if (state.status == PicturesStatus.addPicture) {
            final newPicture = await showDialog<File>(
              context: context,
              builder: (ctx) {
                return const SelectionCameraGallery();
              },
            );
            context.read<AddPicturesCubit>().addedPicture(newPicture);
          } else if (state.status == PicturesStatus.warning) {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('No Pictures'),
                content: const Text(
                  '''
Pictures are important to help you find match.
Are you sure you do not want to add any pictures?''',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            );
            if (confirmed != null && confirmed) {
              context
                  .read<AddPicturesCubit>()
                  .forceSubmit(context.flow<SignupFlowState>());
            } else {
              context.read<AddPicturesCubit>().dismissWarning();
            }
          }
        },
        child: Scaffold(
          appBar: AppBarExtension(
            backButton: true,
            context: context,
            titleText: 'Your Pictures',
            subtitleText: widget.private ? 'Private' : 'Public',
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocBuilder<AddPicturesCubit, AddPicturesState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          childAspectRatio: 3 / 4,
                          crossAxisCount: 3,
                          children: List.generate(
                              max(
                                state.pictures.length + 1,
                                AddPictures.initialEmptySlots,
                              ), (index) {
                            if (index < state.pictures.length) {
                              final picture = state.pictures[index];
                              return PicturePreview(picture: picture);
                            } else {
                              return EmptyPictureSlot(
                                onPressed: () => context
                                    .read<AddPicturesCubit>()
                                    .selectedAddPicture(),
                              );
                            }
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Builder(
                  builder: (context) => SubmitButton(
                    onSubmit: () {
                      context
                          .read<AddPicturesCubit>()
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

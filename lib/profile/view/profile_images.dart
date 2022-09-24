import 'dart:io';

import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/widgets/empty_picture_slot.dart';
import 'package:datingfoss/widgets/picture_preview.dart';
import 'package:datingfoss/widgets/selection_camera_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PublicProfileImages extends StatelessWidget {
  const PublicProfileImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Public Pictures',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ImagesChanger(private: false)
      ],
    );
  }
}

class PrivateProfileImages extends StatelessWidget {
  const PrivateProfileImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Private Pictures',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ImagesChanger(private: true),
      ],
    );
  }
}

class ImagesChanger extends StatelessWidget {
  const ImagesChanger({super.key, required this.private});

  final bool private;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final pictures = private
            ? state.user.privateInfo.pictures.map((e) => e.picId).toList()
            : state.user.publicInfo.pictures;
        return SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: pictures.length + 1,
            itemBuilder: (context, index) {
              if (index < pictures.length) {
                final picturePath = pictures[index];

                final picture = File(picturePath);

                return GestureDetector(
                  onLongPress: () async {
                    final confirmation =
                        await _showDialogConfirmDeletion(context);
                    if (confirmation != null && confirmation == true) {
                      context.read<ProfileBloc>().add(
                            PicDeleted(picId: picturePath, private: private),
                          );
                    }
                  },
                  child: SizedBox(
                    width: 70,
                    child: PicturePreview(picture: picture),
                  ),
                );
              } else {
                return EmptyPictureSlot(
                  onPressed: () async {
                    final newPicture = await showDialog<File>(
                      context: context,
                      builder: (ctx) {
                        return const SelectionCameraGallery();
                      },
                    );
                    context
                        .read<ProfileBloc>()
                        .add(PicAdded(private: private, pic: newPicture));
                  },
                );
              }
            },
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }

  Future<bool?> _showDialogConfirmDeletion(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Deleting picture'),
        content: const Text(
          '''Are you sure you want to delete your pic?''',
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
  }
}

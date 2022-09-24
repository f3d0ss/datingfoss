import 'dart:io';

import 'package:flutter/widgets.dart';

class PicturePreview extends StatelessWidget {
  const PicturePreview({
    super.key,
    required this.picture,
  });

  final File? picture;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: picture != null
            ? Image.file(
                picture!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Image(
                width: 1000,
                image: AssetImage('assets/images/noImageBackground.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

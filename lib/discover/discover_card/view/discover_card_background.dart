import 'package:flutter/material.dart';

class DiscoverCardBackground extends StatelessWidget {
  const DiscoverCardBackground({
    super.key,
    required Image? backgroundImage,
    required String? imageId,
  })  : _backgroundImage = backgroundImage,
        _imageId = imageId;

  final Image? _backgroundImage;
  final String? _imageId;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: (_backgroundImage != null)
            ? Hero(
                tag: _imageId ?? 'noBackground',
                child: _backgroundImage!,
              )
            : const Image(
                image: AssetImage('assets/images/spinner.gif'),
              ),
      ),
    );
  }
}

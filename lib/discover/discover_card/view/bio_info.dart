import 'package:flutter/material.dart';

class BioInfo extends StatelessWidget {
  BioInfo({
    super.key,
    required String bio,
  }) : _bio = (bio.isNotEmpty) ? bio : _NOBIO;

  final String _bio;
  // ignore: constant_identifier_names
  static const String _NOBIO = "I'm a mystery person without a bio";

  @override
  Widget build(BuildContext context) {
    const bioTextStyle = TextStyle(
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 10,
        ),
      ],
    );
    return Text(
      _bio,
      style: bioTextStyle,
      maxLines: 4,
    );
  }
}

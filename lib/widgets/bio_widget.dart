import 'package:flutter/material.dart';

class BioWidget extends StatelessWidget {
  const BioWidget({
    super.key,
    required this.bio,
    required this.private,
  });

  final String bio;
  final bool private;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${private ? 'Private' : 'Public'} Bio:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            bio,
            textAlign: TextAlign.justify,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

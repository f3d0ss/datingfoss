import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class TextInfoRow extends StatelessWidget {
  const TextInfoRow({super.key, required this.id, required this.data});

  final PrivateData<String> data;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (data.private) const Icon(Icons.lock, size: 16),
        Text(
          '${id.capitalize()}:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(' ${data.data.capitalize()}'),
      ],
    );
  }
}

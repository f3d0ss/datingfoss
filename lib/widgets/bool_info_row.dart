import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BoolInfoRow extends StatelessWidget {
  const BoolInfoRow({super.key, required this.id, required this.data});

  final PrivateData<bool> data;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${id.capitalize()}: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (data.private) const Icon(Icons.lock),
        Icon(data.data ? Icons.done : Icons.cancel),
      ],
    );
  }
}

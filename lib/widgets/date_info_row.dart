import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DateInfoRow extends StatelessWidget {
  const DateInfoRow({super.key, required this.id, required this.data});

  final PrivateData<DateTime> data;
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
        Text('${data.data.year}/${data.data.month}/${data.data.day}'),
      ],
    );
  }
}

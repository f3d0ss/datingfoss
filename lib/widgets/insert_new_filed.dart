import 'package:flutter/material.dart';

class InsertNewField extends StatelessWidget {
  InsertNewField({super.key});

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: myController,
              decoration:
                  const InputDecoration(label: Text('Create a new one')),
            ),
          ),
          IconButton(
            onPressed: () {
              if (myController.text != '') {
                final field = myController.text;
                Navigator.of(context).pop(field);
              }
            },
            icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

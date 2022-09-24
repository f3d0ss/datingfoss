import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PrivatizableTextFormField extends StatelessWidget {
  const PrivatizableTextFormField({
    super.key,
    this.onTextChanged,
    this.onPrivateChanged,
    this.initialValue = const PrivateData(''),
    this.labelText,
  });

  final String? labelText;
  final void Function(String)? onTextChanged;
  final void Function(bool)? onPrivateChanged;
  final PrivateData<String> initialValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: labelText),
            initialValue: initialValue.data,
            onChanged: onTextChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: onPrivateChanged != null
                ? () => onPrivateChanged!(!initialValue.private)
                : null,
            icon: Icon(
              initialValue.private ? Icons.lock : Icons.lock_open,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

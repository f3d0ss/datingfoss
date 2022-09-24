import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PrivatizableBoolFormField extends StatelessWidget {
  const PrivatizableBoolFormField({
    super.key,
    this.onBoolChanged,
    this.onPrivateChanged,
    this.initialValue = const PrivateData(true),
    required this.labelBool,
  });

  final String labelBool;
  final void Function(bool?)? onBoolChanged;
  final void Function(bool)? onPrivateChanged;
  final PrivateData<bool> initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                '$labelBool :',
              ),
              Checkbox(value: initialValue.data, onChanged: onBoolChanged),
            ],
          ),
        ),
        IconButton(
          onPressed: onPrivateChanged != null
              ? () => onPrivateChanged!(!initialValue.private)
              : null,
          icon: Icon(
            initialValue.private ? Icons.lock : Icons.lock_open,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PrivatizableSexSlider extends StatelessWidget {
  const PrivatizableSexSlider({
    super.key,
    this.onSexChanged,
    this.onPrivateChanged,
    this.initialValue = const PrivateData(0.5),
  });

  final void Function(double)? onSexChanged;
  final void Function(bool)? onPrivateChanged;
  final PrivateData<double> initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.female),
        Expanded(
          child: Slider(
            label: initialValue.data < 0.5
                ? '${(100 - (initialValue.data) * 100).round()}% Female'
                : '${((initialValue.data) * 100).round()}% Male',
            value: initialValue.data,
            onChanged: onSexChanged,
            divisions: 22,
            activeColor: Colors.blue[100],
            inactiveColor: Colors.pink[100],
            thumbColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Icon(Icons.male),
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

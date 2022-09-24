import 'package:flutter/material.dart';
import 'package:models/models.dart' as models;

class PrivatizableSearchingSlider extends StatelessWidget {
  const PrivatizableSearchingSlider({
    super.key,
    this.onSearchingChanged,
    this.onPrivateChanged,
    this.initialValue = const models.PrivateData(RangeValues(0, 1)),
  });

  final void Function(RangeValues)? onSearchingChanged;
  final void Function(bool)? onPrivateChanged;
  final models.PrivateData<RangeValues> initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.female),
        Expanded(
          child: RangeSlider(
            labels: RangeLabels(
              initialValue.data.start < 0.5
                  ? '''${(100 - (initialValue.data.start) * 100).round()}
                        % Female'''
                  : '''${((initialValue.data.start) * 100).round()}
                        % Male''',
              initialValue.data.end < 0.5
                  ? '''${(100 - (initialValue.data.end) * 100).round()}
                        % Female'''
                  : '''${((initialValue.data.end) * 100).round()}
                        % Male''',
            ),
            values: initialValue.data,
            onChanged: onSearchingChanged,
            divisions: 22,
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

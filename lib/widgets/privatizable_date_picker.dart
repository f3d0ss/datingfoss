import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PrivatizableDatePicker extends StatelessWidget {
  const PrivatizableDatePicker({
    super.key,
    this.onDateChanged,
    this.onPrivateChanged,
    this.initialValue = const PrivateData<DateTime?>(null),
    required this.labelText,
  });

  final String labelText;
  final void Function(DateTime)? onDateChanged;
  final void Function(bool)? onPrivateChanged;
  final PrivateData<DateTime?> initialValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: OutlinedButton(
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined),
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(labelText.capitalize()),
                        if (initialValue.data != null)
                          Text(
                            '${initialValue.data!.day}/${initialValue.data!.month}/${initialValue.data!.year}',
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                lastDate: DateTime.now(),
                context: context,
                firstDate: DateTime.parse('19000101'),
                initialDate: DateTime.now().subtract(
                  const Duration(days: 18 * 365),
                ),
              );
              if (selectedDate != null) {
                onDateChanged!(selectedDate);
              }
            },
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

import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.onSubmit,
    super.key,
  });

  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onSubmit,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

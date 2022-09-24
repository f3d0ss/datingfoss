import 'package:flutter/material.dart';

class EmptyPictureSlot extends StatelessWidget {
  const EmptyPictureSlot({
    super.key,
    this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      child: OutlinedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        onPressed: onPressed,
        child: const Center(
          child: Icon(Icons.add_circle_outline),
        ),
      ),
    );
  }
}

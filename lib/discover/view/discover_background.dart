import 'package:flutter/material.dart';

class DiscoverBackground extends StatelessWidget {
  const DiscoverBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ColoredBox(color: Colors.white),
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Row(),
          ),
        ),
      ],
    );
  }
}

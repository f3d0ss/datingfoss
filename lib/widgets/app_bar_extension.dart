import 'package:flutter/material.dart';

class AppBarExtension extends AppBar {
  AppBarExtension({
    required String titleText,
    String subtitleText = '',
    Widget? actionButton,
    bool backButton = false,
    BuildContext? context,
    super.key,
  }) : super(
          leading: backButton
              ? Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context!);
                      },
                      iconSize: 54,
                      icon: const Icon(Icons.chevron_left_sharp),
                    ),
                  ],
                )
              : null,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [actionButton ?? const Text('')],
              ),
            ),
          ],
          title: SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(subtitleText),
              ],
            ),
          ),
          toolbarHeight: 120,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        );
}

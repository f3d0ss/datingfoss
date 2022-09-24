import 'package:flutter/material.dart';

final theme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.

  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xfff9a825),
    onPrimary: Colors.white,
    secondary: const Color.fromARGB(255, 170, 170, 170),
    surface: const Color.fromARGB(255, 245, 245, 245),
    primaryContainer: const Color(0xfff9a825),
    onTertiary: Colors.white,
    background: const Color.fromARGB(255, 214, 214, 214),
    tertiary: Colors.white,
  ),
);

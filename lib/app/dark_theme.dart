import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.

  colorScheme: const ColorScheme.dark().copyWith(
    primary: const Color(0xfff9a825),
    onPrimary: Colors.white,
    secondary: const Color.fromARGB(255, 170, 170, 170),
    onSecondary: Colors.white,
    primaryContainer: const Color(0xff212121),
    onTertiary: Colors.white,
    surfaceVariant: const Color.fromARGB(255, 64, 64, 64),
    surface: const Color(0xff212121),
    background: const Color(0xff000000),
    tertiary: const Color.fromARGB(255, 46, 46, 46),
  ),

  toggleableActiveColor: const Color(0xfff9a825),
);

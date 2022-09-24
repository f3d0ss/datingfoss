import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/app/dark_theme.dart';
import 'package:datingfoss/app/theme.dart';
import 'package:datingfoss/authentication/login/login.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/main_navigation/main_screen.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.buildBloc<AppBloc>(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DatingFoss',
      theme: theme,
      darkTheme: darkTheme,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}

List<Page<void>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<void>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [MainScreen.page()];
    case AppStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}

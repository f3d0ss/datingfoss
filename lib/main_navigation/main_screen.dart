import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/chat/bloc/chat_state.dart';
import 'package:datingfoss/chat/view/list_chat_screen.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/discover/view/discover_screen.dart';
import 'package:datingfoss/main_navigation/bloc/main_navigation_bloc.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:datingfoss/match/view/match_widget.dart';
import 'package:datingfoss/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static Page<void> page() => const MaterialPage<void>(child: MainScreen());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => context.buildBloc<MainNavigationBloc>(),
        ),
        BlocProvider(create: (context) => context.buildBloc<MatchBloc>()),
        BlocProvider(create: (context) => context.buildBloc<ChatBloc>()),
      ],
      child: BlocBuilder<MainNavigationBloc, MainNavigationState>(
        buildWhen: (previous, current) => previous.mainPage != current.mainPage,
        builder: (context, state) {
          final navigationBar = NavigationBar(
            onTap: (index) =>
                context.read<MainNavigationBloc>().add(_indexToEvent(index)),
            items: _buildBarItems(context),
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            currentIndex: _pageToIndex(state.mainPage),
          );

          return OrientationBuilder(
            builder: (context, orientation) => Scaffold(
              bottomNavigationBar: orientation == Orientation.portrait
                  ? navigationBar.toBottomNavigationBar
                  : null,
              body: Row(
                children: [
                  if (orientation == Orientation.landscape)
                    navigationBar.toNavigationRail,
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    flex: 8,
                    child: Stack(
                      children: [
                        _pageToContent(state.mainPage),
                        const MatchWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<BarItem> _buildBarItems(BuildContext context) => [
        BarItem(
          icon: Icon(
            Icons.explore,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'Explore',
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        BarItem(
          icon: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  if (state.hasMessageUnread)
                    Positioned(
                      // draw a red marble
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.favorite,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                ],
              );
            },
          ),
          label: 'Chat',
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        BarItem(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.secondary,
          ),
          label: 'Profile',
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      ];

  Widget _pageToContent(MainPage page) {
    switch (page) {
      case MainPage.explore:
        return const DiscoverScreen();
      case MainPage.chat:
        return const ListChatScreen();
      case MainPage.profile:
        return const ProfileScreen();
    }
  }

  int _pageToIndex(MainPage page) {
    switch (page) {
      case MainPage.explore:
        return 0;
      case MainPage.chat:
        return 1;
      case MainPage.profile:
        return 2;
    }
  }

  MainNavigationEvent _indexToEvent(int index) {
    switch (index) {
      case 0:
        return PageChangedToExplore();
      case 1:
        return PageChangedToChat();
      case 2:
        return PageChangedToProfile();
    }
    throw Exception();
  }
}

class NavigationBar {
  const NavigationBar({
    required this.onTap,
    required this.items,
    required this.backgroundColor,
    required this.selectedItemColor,
    this.currentIndex = 0,
  });

  final ValueChanged<int>? onTap;
  final List<BarItem> items;
  final int currentIndex;
  final Color? backgroundColor;
  final Color? selectedItemColor;

  BottomNavigationBar get toBottomNavigationBar => BottomNavigationBar(
        backgroundColor: backgroundColor,
        items: items.map((e) => e.toBottomNavigationBarItem).toList(),
        currentIndex: currentIndex,
        selectedItemColor: selectedItemColor,
        onTap: onTap,
      );
  NavigationRail get toNavigationRail => NavigationRail(
        backgroundColor: backgroundColor,
        destinations: items.map((e) => e.toNavigationRailDestination).toList(),
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        selectedLabelTextStyle: TextStyle(color: selectedItemColor),
        selectedIconTheme: IconThemeData(color: selectedItemColor),
        labelType: NavigationRailLabelType.all,
        groupAlignment: 0,
      );
}

class BarItem {
  const BarItem({
    required this.icon,
    required this.label,
    this.backgroundColor,
  });

  final Widget icon;
  final String label;
  final Color? backgroundColor;

  BottomNavigationBarItem get toBottomNavigationBarItem =>
      BottomNavigationBarItem(
        icon: icon,
        label: label,
        backgroundColor: backgroundColor,
      );

  NavigationRailDestination get toNavigationRailDestination =>
      NavigationRailDestination(
        icon: icon,
        label: Text(label),
        padding: const EdgeInsets.symmetric(vertical: 16),
      );
}

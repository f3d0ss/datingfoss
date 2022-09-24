part of 'main_navigation_bloc.dart';

abstract class MainNavigationEvent extends Equatable {
  const MainNavigationEvent();

  @override
  List<Object> get props => [];
}

class PageChangedToExplore extends MainNavigationEvent {}

class PageChangedToChat extends MainNavigationEvent {}

class PageChangedToProfile extends MainNavigationEvent {}

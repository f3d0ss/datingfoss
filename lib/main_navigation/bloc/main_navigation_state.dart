part of 'main_navigation_bloc.dart';

class MainNavigationState extends Equatable {
  const MainNavigationState({
    this.mainPage = MainPage.explore,
  });

  final MainPage mainPage;

  MainNavigationState copyWith({
    MainPage? mainPage,
  }) {
    return MainNavigationState(
      mainPage: mainPage ?? this.mainPage,
    );
  }

  @override
  List<Object> get props => [mainPage];
}

enum MainPage {
  explore,
  chat,
  profile,
}

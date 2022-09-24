import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/main_navigation/bloc/main_navigation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiscoverBloc', () {
    setUp(() {});

    test('initial state is an empty MainNavigationState', () {
      expect(
        MainNavigationBloc().state,
        const MainNavigationState(),
      );
    });
    group('PageChangedToExplore', () {
      blocTest<MainNavigationBloc, MainNavigationState>(
        'emits state with explore as mainPage',
        build: MainNavigationBloc.new,
        act: (bloc) => bloc.add(PageChangedToExplore()),
        expect: () => [const MainNavigationState()],
      );
    });
    group('PageChangedToChat', () {
      blocTest<MainNavigationBloc, MainNavigationState>(
        'emits state with chat as mainPage',
        build: MainNavigationBloc.new,
        act: (bloc) => bloc.add(PageChangedToChat()),
        expect: () => [const MainNavigationState(mainPage: MainPage.chat)],
      );
    });
    group('PageChangedToProfile', () {
      blocTest<MainNavigationBloc, MainNavigationState>(
        'emits state with profile as mainPage',
        build: MainNavigationBloc.new,
        act: (bloc) => bloc.add(PageChangedToProfile()),
        expect: () => [const MainNavigationState(mainPage: MainPage.profile)],
      );
    });
  });
}

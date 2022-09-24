import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_navigation_event.dart';
part 'main_navigation_state.dart';

class MainNavigationBloc
    extends Bloc<MainNavigationEvent, MainNavigationState> {
  MainNavigationBloc() : super(const MainNavigationState()) {
    on<PageChangedToExplore>(_onPageChangedToExplore);
    on<PageChangedToChat>(_onPageChangedToChat);
    on<PageChangedToProfile>(_onPageChangedToProfile);
  }

  FutureOr<void> _onPageChangedToExplore(
    PageChangedToExplore event,
    Emitter<MainNavigationState> emit,
  ) {
    emit(state.copyWith(mainPage: MainPage.explore));
  }

  FutureOr<void> _onPageChangedToChat(
    PageChangedToChat event,
    Emitter<MainNavigationState> emit,
  ) {
    emit(state.copyWith(mainPage: MainPage.chat));
  }

  FutureOr<void> _onPageChangedToProfile(
    PageChangedToProfile event,
    Emitter<MainNavigationState> emit,
  ) {
    emit(state.copyWith(mainPage: MainPage.profile));
  }
}

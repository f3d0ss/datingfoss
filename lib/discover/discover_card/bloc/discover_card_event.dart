part of 'discover_card_bloc.dart';

abstract class DiscoverCardEvent extends Equatable {
  const DiscoverCardEvent();

  @override
  List<Object> get props => [];
}

class AskedLoadPartner extends DiscoverCardEvent {
  const AskedLoadPartner({this.keys});

  final List<String>? keys;
}

class LeftTapped extends DiscoverCardEvent {}

class RightTapped extends DiscoverCardEvent {}

class BottomTapped extends DiscoverCardEvent {}

class ExitedDetailPage extends DiscoverCardEvent {}

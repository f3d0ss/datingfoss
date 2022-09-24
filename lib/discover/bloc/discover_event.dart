part of 'discover_bloc.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverSwiped extends DiscoverEvent {
  const DiscoverSwiped({required this.direction, required this.index});

  final t.SwipeDirection direction;
  final int index;

  @override
  List<Object?> get props => [direction, index];
}

class DiscoverLikeButtonPressed extends DiscoverEvent {}

class DiscoverDiscardButtonPressed extends DiscoverEvent {}

class DiscoverBackButtonPressed extends DiscoverEvent {}

class DiscoverBack extends DiscoverEvent {}

class DiscoverFetchUsersAsked extends DiscoverEvent {}

class DiscoverPartnersFeched extends DiscoverEvent {
  const DiscoverPartnersFeched(this.partner);

  final Partner partner;

  @override
  List<Object?> get props => [partner];
}

class DiscoverPartnerLikeReceived extends DiscoverEvent {
  const DiscoverPartnerLikeReceived(this.addLikeMessage);

  final AddLikeMessage addLikeMessage;

  @override
  List<Object?> get props => [addLikeMessage];
}

class DiscoverPartnerRemoveLikeReceived extends DiscoverEvent {
  const DiscoverPartnerRemoveLikeReceived(this.removeLikeMessage);

  final RemoveLikeMessage removeLikeMessage;

  @override
  List<Object?> get props => [removeLikeMessage];
}

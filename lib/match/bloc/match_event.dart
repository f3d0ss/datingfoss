part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LikeEvent extends MatchEvent {
  const LikeEvent();
}

class PartnerAddedLike extends LikeEvent {
  const PartnerAddedLike(this.likeMessage);
  final AddLikeMessage likeMessage;
  @override
  List<Object> get props => [likeMessage];
}

class UserAddedLike extends LikeEvent {
  const UserAddedLike(this.likeMessage);
  final AddLikeMessage likeMessage;
  @override
  List<Object> get props => [likeMessage];
}

class PartnerRemovedLike extends LikeEvent {
  const PartnerRemovedLike(this.removeLikeMessage);
  final RemoveLikeMessage removeLikeMessage;
  @override
  List<Object> get props => [removeLikeMessage];
}

class UserRemovedLike extends LikeEvent {
  const UserRemovedLike(this.removeLikeMessage);
  final RemoveLikeMessage removeLikeMessage;
  @override
  List<Object> get props => [removeLikeMessage];
}

class TappedNewMatch extends MatchEvent {}

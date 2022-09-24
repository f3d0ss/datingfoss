part of 'match_bloc.dart';

class MatchState extends Equatable {
  const MatchState({
    this.partnerThatLikeMe = const {},
    Map<String, List<String>> partnerThatILike = const {},
    this.newMatch,
    this.undoMatch = '',
  }) : _partnerThatILike = partnerThatILike;

  final Map<String, List<String>> partnerThatLikeMe;
  final Map<String, List<String>> _partnerThatILike;
  final String undoMatch;
  final AddLikeMessage? newMatch;

  MatchState copyWith({
    Map<String, List<String>>? partnerThatLikeMe,
    Map<String, List<String>>? partnerThatILike,
    AddLikeMessage? Function()? newMatch,
    String? undoMatch,
  }) {
    return MatchState(
      newMatch: newMatch != null ? newMatch() : this.newMatch,
      partnerThatILike: partnerThatILike ?? _partnerThatILike,
      partnerThatLikeMe: partnerThatLikeMe ?? this.partnerThatLikeMe,
      undoMatch: undoMatch ?? this.undoMatch,
    );
  }

  @override
  List<Object> get props =>
      [partnerThatLikeMe, _partnerThatILike, newMatch ?? '', undoMatch];
}

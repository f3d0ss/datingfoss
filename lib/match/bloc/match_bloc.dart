import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc({
    required UserRepository userRepository,
    required DiscoverRepository discoverRepository,
  })  : _discoverRepository = discoverRepository,
        super(const MatchState()) {
    on<PartnerAddedLike>(_onPartnerAddedLike);
    on<UserAddedLike>(_onUserAddedLike);
    on<PartnerRemovedLike>(_onPartnerRemovedLike);
    on<UserRemovedLike>(_onUserRemovedLike);
    on<TappedNewMatch>(_onTappedNewMatch);
    _discoverRepository.receivedLike.listen((like) {
      add(PartnerAddedLike(like));
    });
    _discoverRepository.receivedRemoveLike.listen((like) {
      add(PartnerRemovedLike(like));
    });
    _discoverRepository.sendedLike.listen((like) {
      add(UserAddedLike(like));
    });
    _discoverRepository.sendedRemoveLike.listen((like) {
      add(UserRemovedLike(like));
    });
    _discoverRepository.subscribeToLikeMessages(
      username: userRepository.currentUser.username,
    );
  }

  final DiscoverRepository _discoverRepository;

  Future<void> _onUserRemovedLike(
    UserRemovedLike event,
    Emitter<MatchState> emit,
  ) async {
    final username = event.removeLikeMessage.username;
    final partnerThatILike = {...state._partnerThatILike}..remove(username);
    if (_isAMatch(username, state.partnerThatLikeMe)) {
      emit(
        state.copyWith(partnerThatILike: partnerThatILike, undoMatch: username),
      );
      emit(state.copyWith(partnerThatILike: partnerThatILike, undoMatch: ''));
    } else {
      emit(state.copyWith(partnerThatILike: partnerThatILike));
    }
  }

  Future<void> _onPartnerRemovedLike(
    PartnerRemovedLike event,
    Emitter<MatchState> emit,
  ) async {
    final username = event.removeLikeMessage.username;
    final partnerThatLikeMe = {...state.partnerThatLikeMe}..remove(username);
    if (_isAMatch(username, state._partnerThatILike)) {
      emit(
        state.copyWith(
          partnerThatLikeMe: partnerThatLikeMe,
          undoMatch: username,
        ),
      );
      emit(state.copyWith(partnerThatLikeMe: partnerThatLikeMe, undoMatch: ''));
    } else {
      emit(state.copyWith(partnerThatLikeMe: partnerThatLikeMe));
    }
  }

  Future<void> _onUserAddedLike(
    UserAddedLike event,
    Emitter<MatchState> emit,
  ) async {
    final username = event.likeMessage.username;
    final partnerThatILike = {...state._partnerThatILike}..putIfAbsent(
        username,
        () => event.likeMessage.keys,
      );
    if (_isAMatch(username, state.partnerThatLikeMe)) {
      emit(
        state.copyWith(
          partnerThatILike: partnerThatILike,
          newMatch: () => event.likeMessage,
        ),
      );
    } else {
      emit(state.copyWith(partnerThatILike: partnerThatILike));
    }
  }

  Future<void> _onPartnerAddedLike(
    PartnerAddedLike event,
    Emitter<MatchState> emit,
  ) async {
    final username = event.likeMessage.username;
    final partnerThatLikeMe = {...state.partnerThatLikeMe}..update(
        username,
        (_) => event.likeMessage.keys,
        ifAbsent: () => event.likeMessage.keys,
      );
    if (_isAMatch(username, state._partnerThatILike)) {
      emit(
        state.copyWith(
          partnerThatLikeMe: partnerThatLikeMe,
          newMatch: () => event.likeMessage,
        ),
      );
    } else {
      emit(state.copyWith(partnerThatLikeMe: partnerThatLikeMe));
    }
  }

  Future<void> _onTappedNewMatch(
    TappedNewMatch event,
    Emitter<MatchState> emit,
  ) async {
    emit(state.copyWith(newMatch: () => null));
  }

  bool _isAMatch(String username, Map<String, List<String>> partners) {
    return partners.containsKey(username);
  }
}

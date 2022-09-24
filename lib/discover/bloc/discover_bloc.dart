import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:synchronized/extension.dart';
import 'package:tcard/tcard.dart' as t;

part 'discover_event.dart';

class DiscoverBloc extends HydratedBloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc({
    required DiscoverRepository discoverRepository,
    required LocalUser localUser,
  })  : _discoverRepository = discoverRepository,
        _localUser = localUser,
        super(const DiscoverState()) {
    on<DiscoverFetchUsersAsked>(_fetchUsers);
    on<DiscoverPartnersFeched>(_onPartnerFetched);
    on<DiscoverSwiped>(
      _onSwiped,
      transformer: sequential(),
    );
    on<DiscoverBack>(_onBack);
    on<DiscoverLikeButtonPressed>(_onLikePressed);
    on<DiscoverDiscardButtonPressed>(_onDiscardPressed);
    on<DiscoverBackButtonPressed>(_onBackPressed);
    on<DiscoverPartnerLikeReceived>(_onPartnerLikeReceived);
    on<DiscoverPartnerRemoveLikeReceived>(_onPartnerRemoveLikeReceived);
    _partnerSubscription = _discoverRepository.possiblePartners.listen(
      (possiblePartner) => add(DiscoverPartnersFeched(possiblePartner)),
    );
    _likeMessageSubscription = _discoverRepository.receivedLike.listen(
      (likeMessage) => add(DiscoverPartnerLikeReceived(likeMessage)),
    );
    _removeLikeMessageSubscription =
        _discoverRepository.receivedRemoveLike.listen(
      (likeMessage) => add(DiscoverPartnerRemoveLikeReceived(likeMessage)),
    );
  }

  final DiscoverRepository _discoverRepository;
  final LocalUser _localUser;
  late StreamSubscription<Partner> _partnerSubscription;
  late StreamSubscription<AddLikeMessage> _likeMessageSubscription;
  late StreamSubscription<RemoveLikeMessage> _removeLikeMessageSubscription;

  Future<void> _fetchUsers(
    DiscoverFetchUsersAsked event,
    Emitter<DiscoverState> emit,
  ) async {
    await _discoverRepository.fetch(
      numberOfPartners: 4,
      userToKeys: state.partnerThatLikeMe,
      alreadyFetchedUsers: state.partners.map((e) => e.username).toList(),
    );
  }

  Future<void> _onPartnerFetched(
    DiscoverPartnersFeched event,
    Emitter<DiscoverState> emit,
  ) async {
    final partner = event.partner;
    final newPartners = [...state.partners, partner];
    emit(
      state.copyWith(partners: newPartners, status: DiscoverStatus.standard),
    );
  }

  Future<void> _onSwiped(
    DiscoverSwiped event,
    Emitter<DiscoverState> emit,
  ) async {
    late PartnerChoice partnerChoice;
    final swipedPartnerUsername = state.partners[state.frontCardIndex].username;
    if (event.direction == t.SwipeDirection.Left) {
      partnerChoice = PartnerChoice.discard;
    } else {
      partnerChoice = PartnerChoice.like;
      await _discoverRepository.putLike(
        fromUsername: _localUser.username,
        partner: state.partners[state.frontCardIndex],
      );
    }
    final alreadyDecidedPartners = [
      ...state.alreadyDecidedPartners,
      swipedPartnerUsername
    ];
    final newSwipeInfo = DiscoverSwipeInfo(state.frontCardIndex, partnerChoice);
    final swipeInfoList = [...state.swipeInfoList, newSwipeInfo];
    final frontCardIndex = state.frontCardIndex + 1;
    emit(
      state.copyWith(
        status: DiscoverStatus.standard,
        swipeInfoList: swipeInfoList,
        frontCardIndex: frontCardIndex,
        alreadyDecidedPartners: alreadyDecidedPartners,
      ),
    );
    if (frontCardIndex > state.partners.length - 3) {
      await _discoverRepository.fetch(
        numberOfPartners: 4,
        userToKeys: state.partnerThatLikeMe,
        alreadyFetchedUsers: state.partners.map((e) => e.username).toList(),
      );
    }
  }

  Future<void> _onBack(
    DiscoverBack event,
    Emitter<DiscoverState> emit,
  ) async {
    final frontCardIndex = state.frontCardIndex - 1;
    final swipedPartner = state.partners[frontCardIndex];

    if (state.swipeInfoList.last.choice == PartnerChoice.like) {
      await _discoverRepository.removeLike(
        fromUsername: _localUser.username,
        partner: swipedPartner,
      );
    }

    final alreadyDecidedPartners = [...state.alreadyDecidedPartners]
      ..remove(swipedPartner);

    final swipeInfoList = [...state.swipeInfoList]..removeLast();

    emit(
      state.copyWith(
        status: DiscoverStatus.standard,
        swipeInfoList: swipeInfoList,
        frontCardIndex: frontCardIndex,
        alreadyDecidedPartners: alreadyDecidedPartners,
      ),
    );
  }

  Future<void> _onLikePressed(
    DiscoverLikeButtonPressed event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.likeing));
  }

  Future<void> _onDiscardPressed(
    DiscoverDiscardButtonPressed event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverStatus.discarding));
  }

  Future<void> _onBackPressed(
    DiscoverBackButtonPressed event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state.frontCardIndex != 0) {
      emit(state.copyWith(status: DiscoverStatus.backing));
    }
  }

  Future<void> _onPartnerLikeReceived(
    DiscoverPartnerLikeReceived event,
    Emitter<DiscoverState> emit,
  ) async {
    final username = event.addLikeMessage.username;
    await synchronized(() async {
      final newPartnersThatLikeMe = {...state.partnerThatLikeMe}..update(
          username,
          (value) => event.addLikeMessage.keys,
          ifAbsent: () => event.addLikeMessage.keys,
        );
      final newPartners = [...state.partners];
      final partnerIndex =
          newPartners.indexWhere((partner) => partner.username == username);
      if (partnerIndex == -1) {
        newPartners.add(
          await _discoverRepository.fetchPartner(
            username: username,
            keys: event.addLikeMessage.keys,
          ),
        );
      } else {
        newPartners[partnerIndex] = await _discoverRepository.fetchPartner(
          username: username,
          keys: event.addLikeMessage.keys,
        );
      }
      emit(
        state.copyWith(
          partnerThatLikeMe: newPartnersThatLikeMe,
          partners: newPartners,
        ),
      );
    });
  }

  Future<void> _onPartnerRemoveLikeReceived(
    DiscoverPartnerRemoveLikeReceived event,
    Emitter<DiscoverState> emit,
  ) async {
    final username = event.removeLikeMessage.username;
    final newPartnersThatLikeMe = {...state.partnerThatLikeMe}
      ..remove(username);
    final newPartners = [...state.partners];
    final partnerIndex =
        newPartners.indexWhere((partner) => partner.username == username);
    if (partnerIndex != -1) {
      newPartners[partnerIndex] = await _discoverRepository.fetchPartner(
        username: username,
      );
    }
    emit(
      state.copyWith(
        partnerThatLikeMe: newPartnersThatLikeMe,
        partners: newPartners,
      ),
    );
  }

  @override
  Future<void> close() {
    _partnerSubscription.cancel();
    _likeMessageSubscription.cancel();
    _removeLikeMessageSubscription.cancel();
    return super.close();
  }

  @override
  DiscoverState fromJson(Map<String, dynamic> json) {
    return DiscoverState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DiscoverState state) {
    return state.toJson();
  }
}

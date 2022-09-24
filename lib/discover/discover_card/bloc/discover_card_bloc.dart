import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'discover_card_event.dart';
part 'discover_card_state.dart';

class DiscoverCardBloc extends Bloc<DiscoverCardEvent, DiscoverCardState> {
  DiscoverCardBloc({
    required DiscoverRepository discoverRepository,
    required Partner partner,
    required LocalUser authenticatedUser,
  })  : _discoverRepository = discoverRepository,
        super(
          _returnInitialState(discoverRepository, partner, authenticatedUser),
        ) {
    on<AskedLoadPartner>(_onAskedLoadPartner);
    on<RightTapped>(_onRightTapped);
    on<LeftTapped>(_onLeftTapped);
    on<BottomTapped>(_onBottomTapped);
    on<ExitedDetailPage>(_onExitedDetailPage);
  }

  static DiscoverCardState _returnInitialState(
    DiscoverRepository discoverRepository,
    Partner partner,
    LocalUser authenticatedUser,
  ) {
    if (partner.publicInfo.location != null) {
      return DiscoverCardState(
        partner: partner,
        index: 0,
        distance:
            authenticatedUser.getDistance(from: partner.publicInfo.location!),
        pictures: discoverRepository.getPicturesFromCache(partner: partner),
      );
    }
    return DiscoverCardState(
      partner: partner,
      index: 0,
      distance: null,
      pictures: discoverRepository.getPicturesFromCache(partner: partner),
    );
  }

  final DiscoverRepository _discoverRepository;

  Future<void> _onAskedLoadPartner(
    AskedLoadPartner event,
    Emitter<DiscoverCardState> emit,
  ) async {
    final partner = state.partner;
    final newStatePictures = {...state.pictures};
    for (final pictureId in partner.publicInfo.pictures) {
      if (!newStatePictures.containsKey(pictureId)) {
        try {
          final pic = await _discoverRepository.fetchPublicImage(
            username: partner.username,
            id: pictureId,
          );
          newStatePictures.putIfAbsent(
            pictureId,
            () => pic,
          );
          emit(state.copyWith(pictures: {...newStatePictures}));
        } catch (_) {}
      }
    }
    final keys = event.keys;
    if (partner.hasPrivateInfo && keys != null) {
      for (final picture in partner.privateInfo!.pictures) {
        if (!newStatePictures.containsKey(picture.picId)) {
          try {
            final pic = await _discoverRepository.fetchPrivateImage(
              username: partner.username,
              id: picture.picId,
              base64Key: keys[picture.keyIndex],
            );
            newStatePictures.putIfAbsent(
              picture.picId,
              () => pic,
            );
            emit(
              state.copyWith(pictures: {...newStatePictures}),
            );
          } catch (_) {}
        }
      }
    }
  }

  Future<void> _onRightTapped(
    RightTapped event,
    Emitter<DiscoverCardState> emit,
  ) async {
    final maxIndex = state.pictures.length;
    if (state.index + 1 < maxIndex) {
      emit(state.copyWith(index: state.index + 1));
    }
  }

  Future<void> _onLeftTapped(
    LeftTapped event,
    Emitter<DiscoverCardState> emit,
  ) async {
    if (state.index > 0) {
      emit(state.copyWith(index: state.index - 1));
    }
  }

  Future<void> _onBottomTapped(
    BottomTapped event,
    Emitter<DiscoverCardState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverCardStatus.detail));
  }

  Future<void> _onExitedDetailPage(
    ExitedDetailPage event,
    Emitter<DiscoverCardState> emit,
  ) async {
    emit(state.copyWith(status: DiscoverCardStatus.preview));
  }
}

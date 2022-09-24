import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

part 'partner_detail_event.dart';
part 'partner_detail_state.dart';

class PartnerDetailBloc extends Bloc<PartnerDetailEvent, PartnerDetailState> {
  PartnerDetailBloc({
    required DiscoverRepository discoverRepository,
    required String username,
    required List<String>? keys,
  })  : _discoverRepository = discoverRepository,
        super(_initialState(username, keys, discoverRepository)) {
    on<FetchPartnerRequested>(_onFetchPartnerRequested);
  }

  static PartnerDetailState _initialState(
    String username,
    List<String>? keys,
    DiscoverRepository discoverRepository,
  ) {
    final partner =
        discoverRepository.getPartnerFromCache(username: username, keys: keys);
    if (partner == null) return PartnerDetailState(username: username);
    return PartnerDetailState(
      username: username,
      partner: partner,
      pictures: discoverRepository.getPicturesFromCache(partner: partner),
    );
  }

  final DiscoverRepository _discoverRepository;

  Future<void> _onFetchPartnerRequested(
    FetchPartnerRequested event,
    Emitter<PartnerDetailState> emit,
  ) async {
    final keys = event.keys;
    final partner = await _discoverRepository.fetchPartner(
      username: state.username,
      keys: keys,
    );
    emit(state.copyWith(partner: partner));
    final statePictures = {...state.pictures};
    for (final pictureId in partner.publicInfo.pictures) {
      if (!statePictures.containsKey(pictureId)) {
        try {
          final pic = await _discoverRepository.fetchPublicImage(
            username: partner.username,
            id: pictureId,
          );
          statePictures.putIfAbsent(
            pictureId,
            () => pic,
          );
          emit(state.copyWith(pictures: {...statePictures}));
        } catch (_) {}
      }
    }
    if (partner.hasPrivateInfo && keys != null) {
      for (final picture in partner.privateInfo!.pictures) {
        if (!statePictures.containsKey(picture.picId)) {
          try {
            final pic = await _discoverRepository.fetchPrivateImage(
              username: partner.username,
              id: picture.picId,
              base64Key: keys[picture.keyIndex],
            );
            statePictures.putIfAbsent(
              picture.picId,
              () => pic,
            );
            emit(
              state.copyWith(pictures: {...statePictures}),
            );
          } catch (_) {}
        }
      }
    }
  }
}

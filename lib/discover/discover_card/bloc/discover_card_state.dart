part of 'discover_card_bloc.dart';

class DiscoverCardState extends Equatable {
  const DiscoverCardState({
    required this.partner,
    required this.index,
    required this.distance,
    this.status = DiscoverCardStatus.preview,
    this.pictures = const {},
  });

  final Partner partner;
  final int index;
  final double? distance;
  final DiscoverCardStatus status;
  final Map<String, File> pictures;

  DiscoverCardState copyWith({
    Partner? partner,
    int? index,
    double? distance,
    DiscoverCardStatus? status,
    Map<String, File>? pictures,
  }) {
    return DiscoverCardState(
      partner: partner ?? this.partner,
      index: index ?? this.index,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      pictures: pictures ?? this.pictures,
    );
  }

  @override
  List<Object> get props => [partner, index, status, pictures];

  String? get backgroundImageIdFromIndex {
    try {
      return pictures.keys.toList()[index];
    } catch (_) {
      return null;
    }
  }

  bool get hasPictures => hasPrivatePictures || hasPublicPictures;

  bool get hasPublicPictures => partner.publicInfo.pictures.isNotEmpty;

  bool get hasPrivatePictures =>
      partner.hasPrivateInfo && partner.privateInfo!.pictures.isNotEmpty;
}

enum DiscoverCardStatus {
  preview,
  detail,
}

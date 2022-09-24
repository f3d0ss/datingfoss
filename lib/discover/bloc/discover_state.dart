import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'discover_state.g.dart';

enum DiscoverStatus {
  initial,
  standard,
  discarding,
  likeing,
  backing,
}

@JsonSerializable()
class DiscoverState extends Equatable {
  const DiscoverState({
    this.status = DiscoverStatus.initial,
    this.frontCardIndex = 0,
    this.swipeInfoList = const <DiscoverSwipeInfo>[],
    this.alreadyDecidedPartners = const <String>[],
    this.partnerThatLikeMe = const <String, List<String>>{},
    this.partners = const <Partner>[],
  });

  factory DiscoverState.fromJson(Map<String, dynamic> json) =>
      _$DiscoverStateFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverStateToJson(this);

  final DiscoverStatus status;
  final int frontCardIndex;
  final List<DiscoverSwipeInfo> swipeInfoList;
  final List<String> alreadyDecidedPartners;
  final Map<String, List<String>> partnerThatLikeMe;
  final List<Partner> partners;

  DiscoverState copyWith({
    List<Partner>? partners,
    DiscoverStatus? status,
    List<DiscoverSwipeInfo>? swipeInfoList,
    int? frontCardIndex,
    List<String>? alreadyDecidedPartners,
    Map<String, List<String>>? partnerThatLikeMe,
  }) {
    return DiscoverState(
      partners: partners ?? this.partners,
      status: status ?? this.status,
      swipeInfoList: swipeInfoList ?? this.swipeInfoList,
      frontCardIndex: frontCardIndex ?? this.frontCardIndex,
      alreadyDecidedPartners:
          alreadyDecidedPartners ?? this.alreadyDecidedPartners,
      partnerThatLikeMe: partnerThatLikeMe ?? this.partnerThatLikeMe,
    );
  }

  List<Partner> get swipablePartners => [...partners];

  @override
  List<Object> get props => [
        partners,
        status,
        swipeInfoList,
        frontCardIndex,
        partnerThatLikeMe,
      ];
}

enum PartnerChoice {
  like,
  discard,
}

@JsonSerializable()
class DiscoverSwipeInfo extends Equatable {
  const DiscoverSwipeInfo(
    this.partnerIndex,
    this.choice,
  );

  factory DiscoverSwipeInfo.fromJson(Map<String, dynamic> json) =>
      _$DiscoverSwipeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverSwipeInfoToJson(this);

  final int partnerIndex;
  final PartnerChoice choice;

  @override
  List<Object?> get props => [partnerIndex, choice];
}

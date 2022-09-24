// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverState _$DiscoverStateFromJson(Map<String, dynamic> json) =>
    DiscoverState(
      status: $enumDecodeNullable(_$DiscoverStatusEnumMap, json['status']) ??
          DiscoverStatus.initial,
      frontCardIndex: json['frontCardIndex'] as int? ?? 0,
      swipeInfoList: (json['swipeInfoList'] as List<dynamic>?)
              ?.map(
                  (e) => DiscoverSwipeInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DiscoverSwipeInfo>[],
      alreadyDecidedPartners: (json['alreadyDecidedPartners'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      partnerThatLikeMe:
          (json['partnerThatLikeMe'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as String).toList()),
              ) ??
              const <String, List<String>>{},
      partners: (json['partners'] as List<dynamic>?)
              ?.map((e) => Partner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Partner>[],
    );

Map<String, dynamic> _$DiscoverStateToJson(DiscoverState instance) =>
    <String, dynamic>{
      'status': _$DiscoverStatusEnumMap[instance.status],
      'frontCardIndex': instance.frontCardIndex,
      'swipeInfoList': instance.swipeInfoList,
      'alreadyDecidedPartners': instance.alreadyDecidedPartners,
      'partnerThatLikeMe': instance.partnerThatLikeMe,
      'partners': instance.partners,
    };

const _$DiscoverStatusEnumMap = {
  DiscoverStatus.initial: 'initial',
  DiscoverStatus.standard: 'standard',
  DiscoverStatus.discarding: 'discarding',
  DiscoverStatus.likeing: 'likeing',
  DiscoverStatus.backing: 'backing',
};

DiscoverSwipeInfo _$DiscoverSwipeInfoFromJson(Map<String, dynamic> json) =>
    DiscoverSwipeInfo(
      json['partnerIndex'] as int,
      $enumDecode(_$PartnerChoiceEnumMap, json['choice']),
    );

Map<String, dynamic> _$DiscoverSwipeInfoToJson(DiscoverSwipeInfo instance) =>
    <String, dynamic>{
      'partnerIndex': instance.partnerIndex,
      'choice': _$PartnerChoiceEnumMap[instance.choice],
    };

const _$PartnerChoiceEnumMap = {
  PartnerChoice.like: 'like',
  PartnerChoice.discard: 'discard',
};

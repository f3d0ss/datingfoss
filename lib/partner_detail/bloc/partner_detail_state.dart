part of 'partner_detail_bloc.dart';

class PartnerDetailState extends Equatable {
  const PartnerDetailState({
    required this.username,
    this.partner = Partner.empty,
    this.pictures = const {},
  });

  final String username;
  final Partner partner;
  final Map<String, File> pictures;

  PartnerDetailState copyWith({
    String? username,
    Partner? partner,
    Map<String, File>? pictures,
  }) {
    return PartnerDetailState(
      partner: partner ?? this.partner,
      pictures: pictures ?? this.pictures,
      username: username ?? this.username,
    );
  }

  @override
  List<Object> get props => [
        username,
        pictures,
        partner,
      ];
}

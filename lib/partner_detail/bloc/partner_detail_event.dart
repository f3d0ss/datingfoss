part of 'partner_detail_bloc.dart';

abstract class PartnerDetailEvent extends Equatable {
  const PartnerDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchPartnerRequested extends PartnerDetailEvent {
  const FetchPartnerRequested(this.keys);

  final List<String>? keys;
}

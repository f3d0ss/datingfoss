import 'package:datingfoss/partner_detail/view/partner_detail_page.dart';
import 'package:flutter/material.dart';

class PartnerDetailScreen extends StatelessWidget {
  const PartnerDetailScreen({
    required this.partnerUsername,
    List<String>? keys,
    super.key,
  }) : _keys = keys;

  static Route<void> route({
    required String partnerUsername,
    List<String>? keys,
  }) {
    return MaterialPageRoute<dynamic>(
      builder: (_) =>
          PartnerDetailScreen(partnerUsername: partnerUsername, keys: keys),
    );
  }

  final String partnerUsername;
  final List<String>? _keys;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PartnerDetailPage(
          partnerUsername: partnerUsername,
          keys: _keys,
        ),
      );
}

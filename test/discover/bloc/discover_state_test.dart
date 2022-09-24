// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockPartner extends Mock implements Partner {}

void main() {
  group('DiscoverState', () {
    test('can converto to and from json', () {
      final partners = [
        Partner(
          username: 'bob',
          jsonPublicKey: const {},
          publicInfo: PublicInfo(),
        )
      ];
      final state = DiscoverState(
        partners: partners,
        status: DiscoverStatus.standard,
        swipeInfoList: const [DiscoverSwipeInfo(0, PartnerChoice.like)],
        partnerThatLikeMe: const {'bob': []},
      );
      expect(
        state,
        DiscoverState.fromJson(
          jsonDecode(jsonEncode(state)) as Map<String, dynamic>,
        ),
      );
    });
    group('swipableUsernames', () {
      final partners = [MockPartner()];
      test('give correct usernames', () {
        final state = DiscoverState(
          partners: partners,
          status: DiscoverStatus.standard,
        );
        expect(state.status, DiscoverStatus.standard);
        expect(state.swipablePartners, partners);
      });
    });

    group('copyWith', () {
      test('returns a copy', () {
        final state = DiscoverState();
        expect(state, state.copyWith());
      });
    });
  });
}

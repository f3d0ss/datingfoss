// ignore_for_file: prefer_const_constructors
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:tcard/tcard.dart';

class MockPartner extends Mock implements Partner {}

void main() {
  group('DiscoverEvent', () {
    group('DiscoverSwiped', () {
      const direction = SwipeDirection.Left;
      const index = 1;
      test('supports value comparisons', () {
        expect(
          DiscoverSwiped(direction: direction, index: index),
          DiscoverSwiped(direction: direction, index: index),
        );
      });
    });

    group('DiscoverLikeButtonPressed', () {
      test('supports value comparisons', () {
        expect(
          DiscoverLikeButtonPressed(),
          DiscoverLikeButtonPressed(),
        );
      });
    });

    group('DiscoverDiscardButtonPressed', () {
      test('supports value comparisons', () {
        expect(
          DiscoverDiscardButtonPressed(),
          DiscoverDiscardButtonPressed(),
        );
      });
    });

    group('DiscoverBackButtonPressed', () {
      test('supports value comparisons', () {
        expect(
          DiscoverBackButtonPressed(),
          DiscoverBackButtonPressed(),
        );
      });
    });

    group('DiscoverBack', () {
      test('supports value comparisons', () {
        expect(
          DiscoverBack(),
          DiscoverBack(),
        );
      });
    });

    group('DiscoverFetchUsersAsked', () {
      test('supports value comparisons', () {
        expect(
          DiscoverFetchUsersAsked(),
          DiscoverFetchUsersAsked(),
        );
      });
    });

    group('DiscoverPartnersFeched', () {
      final partner = MockPartner();
      test('supports value comparisons', () {
        expect(
          DiscoverPartnersFeched(partner),
          DiscoverPartnersFeched(partner),
        );
      });
    });

    group('DiscoverPartnerLikeReceived', () {
      final addLike = AddLikeMessage(username: 'username', keys: const []);
      test('supports value comparisons', () {
        expect(
          DiscoverPartnerLikeReceived(addLike),
          DiscoverPartnerLikeReceived(addLike),
        );
      });
    });

    group('DiscoverPartnerRemoveLikeReceived', () {
      final removeLike = RemoveLikeMessage(username: 'username');
      test('supports value comparisons', () {
        expect(
          DiscoverPartnerRemoveLikeReceived(removeLike),
          DiscoverPartnerRemoveLikeReceived(removeLike),
        );
      });
    });
  });
}

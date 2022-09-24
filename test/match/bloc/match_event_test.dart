import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockUser extends Mock implements LocalUser {}

class MockAddLikeMessage extends Mock implements AddLikeMessage {}

class MockRemoveLikeMessage extends Mock implements RemoveLikeMessage {}

void main() {
  group('MatchEvent', () {
    group('LikeEvent', () {
      test('supports value comparisons', () {
        expect(
          const LikeEvent(),
          const LikeEvent(),
        );
      });
    });

    group('PartnerAddedLike', () {
      final likeMessage = MockAddLikeMessage();
      test('supports value comparisons', () {
        expect(
          PartnerAddedLike(likeMessage),
          PartnerAddedLike(likeMessage),
        );
      });
    });
    group('UserAddedLike', () {
      final likeMessage = MockAddLikeMessage();
      test('supports value comparisons', () {
        expect(
          UserAddedLike(likeMessage),
          UserAddedLike(likeMessage),
        );
      });
    });
    group('PartnerRemovedLike', () {
      final likeMessage = MockRemoveLikeMessage();
      test('supports value comparisons', () {
        expect(
          PartnerRemovedLike(likeMessage),
          PartnerRemovedLike(likeMessage),
        );
      });
    });
    group('UserRemovedLike', () {
      final likeMessage = MockRemoveLikeMessage();
      test('supports value comparisons', () {
        expect(
          UserRemovedLike(likeMessage),
          UserRemovedLike(likeMessage),
        );
      });
    });
  });
}

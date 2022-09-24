import 'dart:async';

import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:tcard/tcard.dart';

import '../../helpers/hydrated_bloc.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

class MockPartner extends Mock implements Partner {}

class MockLocalUser extends Mock implements LocalUser {}

void main() {
  group('DiscoverBloc', () {
    late DiscoverRepository discoverRepository;
    late LocalUser localUser;
    late String localUsername;

    setUp(() {
      discoverRepository = MockDiscoverRepository();
      localUser = MockLocalUser();
      localUsername = 'pippo';
      when(() => discoverRepository.possiblePartners).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => discoverRepository.receivedLike).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => discoverRepository.receivedRemoveLike).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => localUser.username).thenReturn(localUsername);
    });

    test('initial state is discover state in initial status', () async {
      mockHydratedStorage();
      expect(
        DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        ).state,
        const DiscoverState(),
      );
    });

    group('DiscoverFetchUsersAsked', () {
      setUp(() {
        when(
          () => discoverRepository.fetch(
            numberOfPartners: any(named: 'numberOfPartners'),
            userToKeys: any(named: 'userToKeys'),
            alreadyFetchedUsers: any(named: 'alreadyFetchedUsers'),
          ),
        ).thenAnswer((_) async {});
      });
      test('invokes fetch', () async {
        mockHydratedStorage();
        DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        ).add(DiscoverFetchUsersAsked());
        await Future<void>.delayed(const Duration(milliseconds: 300));
        verify(
          () => discoverRepository.fetch(
            numberOfPartners: any(named: 'numberOfPartners'),
            userToKeys: any(named: 'userToKeys'),
            alreadyFetchedUsers: any(named: 'alreadyFetchedUsers'),
          ),
        ).called(1);
      });
    });

    group('DiscoverPartnersFeched', () {
      final mockPartners = [MockPartner(), MockPartner()];
      setUp(() {
        when(() => discoverRepository.possiblePartners).thenAnswer(
          (_) => Stream.fromIterable(mockPartners),
        );
        when(() => mockPartners[0].username).thenAnswer((_) => 'pippo');
        when(() => mockPartners[1].username).thenAnswer((_) => 'pippa');
        when(() => mockPartners[0].toJson()).thenReturn({});
        when(() => mockPartners[1].toJson()).thenReturn({});
      });
      test('emits standard status when partners are fetched', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        );
        await expectLater(
          bloc.stream,
          emitsInOrder(
            [
              DiscoverState(
                status: DiscoverStatus.standard,
                partners: [mockPartners[0]],
              ),
              DiscoverState(
                status: DiscoverStatus.standard,
                partners: mockPartners,
              ),
            ],
          ),
        );
      });
    });

    group('DiscoverSwiped', () {
      final mockPartners = [MockPartner(), MockPartner()];
      const username = 'username';
      setUp(() {
        when(() => mockPartners[0].toJson()).thenReturn(<String, dynamic>{});
        when(() => mockPartners[1].toJson()).thenReturn(<String, dynamic>{});
        when(() => mockPartners[0].username).thenReturn(username);
        when(() => mockPartners[1].username).thenReturn(username);
        when(
          () => discoverRepository.putLike(
            fromUsername: localUsername,
            partner: mockPartners[0],
          ),
        ).thenAnswer(
          (_) async {},
        );
        when(
          () => discoverRepository.fetch(
            numberOfPartners: any(named: 'numberOfPartners'),
            userToKeys: any(named: 'userToKeys'),
            alreadyFetchedUsers: any(named: 'alreadyFetchedUsers'),
          ),
        ).thenAnswer((_) async {});
      });
      test('swiped right', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(DiscoverState(partners: mockPartners))
          ..add(
            const DiscoverSwiped(direction: SwipeDirection.Right, index: 0),
          );
        await expectLater(
          bloc.stream,
          emitsInOrder([
            DiscoverState(
              status: DiscoverStatus.standard,
              partners: mockPartners,
              swipeInfoList: const [DiscoverSwipeInfo(0, PartnerChoice.like)],
              frontCardIndex: 1,
              alreadyDecidedPartners: const [username],
            )
          ]),
        );
        verify(
          () => discoverRepository.putLike(
            partner: mockPartners[0],
            fromUsername: localUsername,
          ),
        ).called(1);
      });

      test('swiped left', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(DiscoverState(partners: mockPartners))
          ..add(
            const DiscoverSwiped(direction: SwipeDirection.Left, index: 0),
          );
        await expectLater(
          bloc.stream,
          emitsInOrder([
            DiscoverState(
              status: DiscoverStatus.standard,
              partners: mockPartners,
              swipeInfoList: const [
                DiscoverSwipeInfo(0, PartnerChoice.discard)
              ],
              frontCardIndex: 1,
              alreadyDecidedPartners: const [username],
            )
          ]),
        );
      });
    });

    group('DiscoverBack', () {
      final mockPartners = [MockPartner(), MockPartner()];
      const mockStatus = DiscoverStatus.standard;
      final mockSwipeInfoList = <DiscoverSwipeInfo>[];
      final mockPartnerThatILike = <String, String>{};
      final mockAlreadyDecidedPartners = <String>[];
      const mockLikeMessage = 'likeMessage';

      setUp(() {
        mockSwipeInfoList.add(const DiscoverSwipeInfo(0, PartnerChoice.like));
        when(() => mockPartners[0].username).thenAnswer((_) => 'pippo');
        when(() => mockPartners[1].username).thenAnswer((_) => 'pippa');
        when(() => mockPartners[0].toJson()).thenReturn({});
        when(() => mockPartners[1].toJson()).thenReturn({});
        mockPartnerThatILike.putIfAbsent(
          mockPartners[0].username,
          () => mockLikeMessage,
        );
        mockAlreadyDecidedPartners.add(mockPartners[0].username);
        when(
          () => discoverRepository.removeLike(
            partner: mockPartners[0],
            fromUsername: localUsername,
          ),
        ).thenAnswer(
          (_) async {},
        );
      });
      test('reverse swipe', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(
            DiscoverState(
              partners: mockPartners,
              status: mockStatus,
              swipeInfoList: mockSwipeInfoList,
              frontCardIndex: 1,
              alreadyDecidedPartners: mockAlreadyDecidedPartners,
            ),
          )
          ..add(DiscoverBack());
        await expectLater(
          bloc.stream,
          emitsInOrder([
            DiscoverState(
              status: DiscoverStatus.standard,
              partners: mockPartners,
            )
          ]),
        );
        verify(
          () => discoverRepository.removeLike(
            partner: mockPartners[0],
            fromUsername: localUsername,
          ),
        ).called(1);
      });
    });

    group('DiscoverLikeButtonPressed', () {
      const mockStatus = DiscoverStatus.standard;
      test('on like pressed change state to likeing', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(const DiscoverState(status: mockStatus))
          ..add(DiscoverLikeButtonPressed());
        await expectLater(
          bloc.stream,
          emits(
            const DiscoverState(
              status: DiscoverStatus.likeing,
            ),
          ),
        );
      });
    });

    group('DiscoverDiscardButtonPressed', () {
      const mockStatus = DiscoverStatus.standard;
      test('on discard pressed change state to discarding', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(const DiscoverState(status: mockStatus))
          ..add(DiscoverDiscardButtonPressed());
        await expectLater(
          bloc.stream,
          emits(const DiscoverState(status: DiscoverStatus.discarding)),
        );
      });
    });

    group('DiscoverBackButtonPressed', () {
      const mockStatus = DiscoverStatus.standard;
      test('on back pressed change state to backing', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )
          ..emit(const DiscoverState(status: mockStatus, frontCardIndex: 1))
          ..add(DiscoverBackButtonPressed());
        await expectLater(
          bloc.stream,
          emits(
            const DiscoverState(
              status: DiscoverStatus.backing,
              frontCardIndex: 1,
            ),
          ),
        );
      });
    });

    group('DiscoverPartnerLikeReceived', () {
      final receivedLikeStream = StreamController<AddLikeMessage>.broadcast();
      const partnerUsername = 'bob';
      final partnerKeys = [''];
      const partner = Partner(
        username: partnerUsername,
        publicInfo: PublicInfo.empty,
        jsonPublicKey: {},
      );
      setUp(() {
        when(() => discoverRepository.receivedLike)
            .thenAnswer((_) => receivedLikeStream.stream);
        when(
          () => discoverRepository.fetchPartner(
            username: partnerUsername,
            keys: partnerKeys,
          ),
        ).thenAnswer((_) async => partner);
      });
      test('''on like received without the partner in the state 
          add to partnerThatLikeMe''', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )..emit(const DiscoverState());
        receivedLikeStream.add(
          AddLikeMessage(username: partnerUsername, keys: partnerKeys),
        );
        await expectLater(
          bloc.stream,
          emits(
            DiscoverState(
              partners: const [partner],
              partnerThatLikeMe: {partnerUsername: partnerKeys},
            ),
          ),
        );
      });

      test('''on like received with the partner in the state 
          add to partnerThatLikeMe''', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )..emit(const DiscoverState(partners: [partner]));
        receivedLikeStream.add(
          AddLikeMessage(username: partnerUsername, keys: partnerKeys),
        );
        await expectLater(
          bloc.stream,
          emits(
            DiscoverState(
              partners: const [partner],
              partnerThatLikeMe: {partnerUsername: partnerKeys},
            ),
          ),
        );
      });
    });

    group('DiscoverPartnerRemoveLikeReceived', () {
      final receivedRemoveLikeStream =
          StreamController<RemoveLikeMessage>.broadcast();
      const partnerUsername = 'bob';
      final partnerKeys = [''];
      const partner = Partner(
        username: partnerUsername,
        publicInfo: PublicInfo.empty,
        jsonPublicKey: {},
      );
      setUp(() {
        when(() => discoverRepository.receivedRemoveLike)
            .thenAnswer((_) => receivedRemoveLikeStream.stream);
        when(
          () => discoverRepository.fetchPartner(username: partnerUsername),
        ).thenAnswer((_) async => partner);
      });
      test('''on remove like received without the partner in the state 
          add to partnerThatLikeMe''', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )..emit(
            DiscoverState(
              partnerThatLikeMe: {partnerUsername: partnerKeys},
            ),
          );
        receivedRemoveLikeStream.add(
          const RemoveLikeMessage(username: partnerUsername),
        );
        await expectLater(
          bloc.stream,
          emits(const DiscoverState()),
        );
      });

      test('''on remove like received with the partner in the state 
          add to partnerThatLikeMe''', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        )..emit(
            DiscoverState(
              partners: const [partner],
              partnerThatLikeMe: {partnerUsername: partnerKeys},
            ),
          );
        receivedRemoveLikeStream.add(
          const RemoveLikeMessage(username: partnerUsername),
        );
        await expectLater(
          bloc.stream,
          emits(
            const DiscoverState(partners: [partner]),
          ),
        );
      });
    });

    group('close', () {
      test('''on close remove subscription''', () async {
        mockHydratedStorage();
        final bloc = DiscoverBloc(
          discoverRepository: discoverRepository,
          localUser: localUser,
        );
        await bloc.close();
      });
    });
  });
}

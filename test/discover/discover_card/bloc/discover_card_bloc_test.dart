// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

class MockUser extends Mock implements LocalUser {}

void main() {
  group('DiscoverCardBloc', () {
    late DiscoverRepository discoverRepository;
    late LocalUser localUser;
    late File pic;
    var partner = Partner(
      username: 'username',
      publicInfo: PublicInfo(),
      jsonPublicKey: const {},
    );

    setUpAll(() => registerFallbackValue(Partner.empty));

    setUp(() async {
      pic = File('test_resources/pic1.jpg');
      localUser = MockUser();
      discoverRepository = MockDiscoverRepository();
      when(() => localUser.location).thenReturn(null);
      when(
        () => discoverRepository.fetchPublicImage(
          username: any(named: 'username'),
          id: any(named: 'id'),
        ),
      ).thenAnswer(
        (_) async => pic,
      );
      when(
        () => discoverRepository.fetchPrivateImage(
          username: any(named: 'username'),
          id: any(named: 'id'),
          base64Key: any(named: 'base64Key'),
        ),
      ).thenAnswer(
        (_) async => pic,
      );
      when(
        () => discoverRepository.getPicturesFromCache(
          partner: any(named: 'partner'),
        ),
      ).thenAnswer((invocation) => {});
    });

    test('initial state is DiscoverCardState', () {
      expect(
        DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ).state,
        isA<DiscoverCardState>(),
      );
    });
    group('AskedLoadPartner', () {
      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'do not emit with partner without pic',
        setUp: () {},
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        act: (bloc) => bloc.add(AskedLoadPartner()),
        expect: () => <DiscoverCardState>[],
      );

      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'load pictures',
        setUp: () {
          partner = Partner(
            username: 'username',
            publicInfo: PublicInfo(pictures: const ['picId']),
            privateInfo: PrivateInfo(
              pictures: const [PrivatePic(picId: 'privatePicId', keyIndex: 0)],
            ),
            jsonPublicKey: const {},
          );
        },
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        act: (bloc) => bloc.add(AskedLoadPartner(keys: const [''])),
        expect: () => [
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
            pictures: {'picId': pic},
          ),
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
            pictures: {'picId': pic, 'privatePicId': pic},
          ),
        ],
      );
    });

    final pic1 = File('');
    final pic2 = File('');
    group('RightTapped', () {
      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'increment the index',
        setUp: () {
          partner = Partner(
            username: 'username',
            publicInfo: PublicInfo(pictures: const ['picId']),
            privateInfo: PrivateInfo(
              pictures: const [PrivatePic(picId: 'privatePicId', keyIndex: 0)],
            ),
            jsonPublicKey: const {},
          );
        },
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        seed: () => DiscoverCardState(
          partner: partner,
          index: 0,
          distance: null,
          pictures: {'pic1': pic1, 'pic2': pic2},
        ),
        act: (bloc) => bloc.add(RightTapped()),
        expect: () => [
          DiscoverCardState(
            partner: partner,
            index: 1,
            distance: null,
            pictures: {'pic1': pic1, 'pic2': pic2},
          )
        ],
      );
    });
    group('LeftTapped', () {
      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'decrement the index',
        setUp: () {
          partner = Partner(
            username: 'username',
            publicInfo: PublicInfo(pictures: const ['picId']),
            privateInfo: PrivateInfo(
              pictures: const [PrivatePic(picId: 'privatePicId', keyIndex: 0)],
            ),
            jsonPublicKey: const {},
          );
        },
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        seed: () => DiscoverCardState(
          partner: partner,
          index: 1,
          distance: null,
        ),
        act: (bloc) => bloc.add(LeftTapped()),
        expect: () => [
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
          )
        ],
      );
    });
    group('BottomTapped', () {
      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'change status to preview',
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        act: (bloc) => bloc.add(BottomTapped()),
        expect: () => [
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
            status: DiscoverCardStatus.detail,
          )
        ],
      );
    });
    group('ExitedDetailPage', () {
      blocTest<DiscoverCardBloc, DiscoverCardState>(
        'change status to preview',
        build: () => DiscoverCardBloc(
          discoverRepository: discoverRepository,
          partner: partner,
          authenticatedUser: localUser,
        ),
        seed: () => DiscoverCardState(
          partner: partner,
          index: 0,
          distance: null,
          status: DiscoverCardStatus.detail,
        ),
        act: (bloc) => bloc.add(ExitedDetailPage()),
        expect: () => [
          DiscoverCardState(
            partner: partner,
            index: 0,
            distance: null,
          )
        ],
      );
    });
  });
}

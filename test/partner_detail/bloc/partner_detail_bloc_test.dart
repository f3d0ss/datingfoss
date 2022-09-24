import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

void main() {
  group('PartnerDetailBloc', () {
    late DiscoverRepository discoverRepository;
    late String partnerUsername;
    late List<String> partnerKeys;
    late File pic;
    late Partner partner;

    setUp(() async {
      pic = File('test_resources/pic1.jpg');
      partnerUsername = 'bob';
      partnerKeys = ['key1'];
      partner = Partner(
        username: partnerUsername,
        publicInfo: const PublicInfo(pictures: ['picId1']),
        privateInfo: const PrivateInfo(
          pictures: [PrivatePic(picId: 'privPicId', keyIndex: 0)],
        ),
        jsonPublicKey: const {},
      );
      discoverRepository = MockDiscoverRepository();
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
        () => discoverRepository.fetchPartner(
          username: partnerUsername,
          keys: partnerKeys,
        ),
      ).thenAnswer(
        (_) async => partner,
      );
    });

    test('initial state is DiscoverCardState', () {
      expect(
        PartnerDetailBloc(
          discoverRepository: discoverRepository,
          username: partnerUsername,
          keys: partnerKeys,
        ).state,
        isA<PartnerDetailState>(),
      );
    });
    group('FetchPartnerRequested', () {
      blocTest<PartnerDetailBloc, PartnerDetailState>(
        'fetch the partner and put it in the state',
        setUp: () {},
        build: () => PartnerDetailBloc(
          discoverRepository: discoverRepository,
          username: partnerUsername,
          keys: partnerKeys,
        ),
        act: (bloc) => bloc.add(FetchPartnerRequested(partnerKeys)),
        expect: () => <PartnerDetailState>[
          PartnerDetailState(username: partnerUsername, partner: partner),
          PartnerDetailState(
            username: partnerUsername,
            partner: partner,
            pictures: {'picId1': pic},
          ),
          PartnerDetailState(
            username: partnerUsername,
            partner: partner,
            pictures: {'picId1': pic, 'privPicId': pic},
          ),
        ],
      );
    });
  });
}

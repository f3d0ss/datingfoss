import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/partner_detail/bloc/partner_detail_bloc.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart' as model;

class MockPartnerDetailBloc extends Mock implements PartnerDetailBloc {}

class MockAppBloc extends Mock implements AppBloc {}

class MockLocalUser extends Mock implements model.LocalUser {}

void main() {
  late PartnerDetailBloc partnerDetailBloc;
  late AppBloc appBloc;
  late model.LocalUser localUser;
  late String partnerUsername;
  late List<String> partnerKeys;
  late File pic;
  late model.Partner partner;

  setUpAll(() {
    registerFallbackValue(LatLng(0, 0));
    partnerDetailBloc = MockPartnerDetailBloc();
    appBloc = MockAppBloc();
    localUser = MockLocalUser();
    pic = File('test_resources/pic1.jpg');
    partnerUsername = 'bob';
    partnerKeys = ['key1'];
    partner = model.Partner(
      username: partnerUsername,
      publicInfo: model.PublicInfo(
        pictures: const ['picId1'],
        interests: const ['interest1'],
        location: LatLng(0, 0),
        textInfo: const {'name': 'bob'},
        boolInfo: const {'boolInfo': true},
        dateInfo: {'dateInfo': DateTime(1990)},
        sex: 0.1,
        searching: const model.RangeValues(0.1, 0.9),
      ),
      privateInfo: const model.PrivateInfo(
        pictures: [model.PrivatePic(picId: 'privPicId', keyIndex: 0)],
        interests: ['privInterest'],
      ),
      jsonPublicKey: const {},
    );
    when(() => localUser.interests)
        .thenReturn([const model.PrivateData('interest1')]);
    when(() => localUser.getDistance(from: any(named: 'from'))).thenReturn(12);
    when(() => appBloc.state).thenReturn(AppState.authenticated(localUser));
    when(() => partnerDetailBloc.close()).thenAnswer((_) async {});
    whenListen(appBloc, Stream.value(AppState.authenticated(localUser)));
    GetIt.I.registerFactoryParam((param1, param2) => partnerDetailBloc);
  });
  group('PartnerDetailPage', () {
    setUp(() {
      when(() => partnerDetailBloc.state)
          .thenReturn(PartnerDetailState(username: partnerUsername));
      whenListen(
        partnerDetailBloc,
        Stream.fromIterable([
          PartnerDetailState(username: partnerUsername),
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
        ]),
      );
    });

    testWidgets('add FetchPartnerRequested event to PartnerDetailBloc',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: PartnerDetailScreen(
              partnerUsername: partnerUsername,
              keys: partnerKeys,
            ),
          ),
        ),
      );
      await tester.pump();
      verify(() => partnerDetailBloc.add(FetchPartnerRequested(partnerKeys)))
          .called(1);
    });
  });
}

import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockLocalUser extends Mock implements LocalUser {}

void main() {
  group('PartnerDetailBloc', () {
    late UserRepository userRepository;
    late LocalUser localUser;
    late File pic;
    late StandardInfo standardInfo;
    late List<String> interests;
    late String picId;
    late String bio;
    late double sex;
    late double latitude;
    late double longitude;
    late RangeValues searching;

    setUp(() async {
      pic = File('test_resources/pic1.jpg');
      localUser = MockLocalUser();
      interests = [];
      bio = 'bio';
      picId = 'picId';
      sex = 0.8;
      searching = const RangeValues(0, 0.5);
      latitude = 12;
      longitude = 12;
      standardInfo =
          const StandardInfo(textInfo: {}, dateInfo: {}, boolInfo: {});
      userRepository = MockUserRepository();
      when(() => userRepository.currentUser).thenReturn(localUser);
      when(() => userRepository.editStandardInfo(standardInfo)).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.editInterests(
          interests: interests,
          private: any(named: 'private'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.editBio(bio: bio, private: any(named: 'private')),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.addPic(pic: pic, private: any(named: 'private')),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.deletePic(
          picId: picId,
          private: any(named: 'private'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.editSexAndOrientation(
          sex: sex,
          isSexPrivate: any(named: 'isSexPrivate'),
          searching: searching,
          isSearchingPrivate: any(named: 'isSearchingPrivate'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => userRepository.editLocation(
          latitude: latitude,
          longitude: longitude,
          private: any(named: 'private'),
        ),
      ).thenAnswer(
        (_) async {},
      );
    });

    test('initial state is ProfileState', () {
      expect(
        ProfileBloc(userRepository: userRepository).state,
        isA<ProfileState>(),
      );
    });
    group('StandardInfoEdited', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository editStandardInfo',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(StandardInfoEdited(standardInfo)),
        verify: (_) =>
            verify(() => userRepository.editStandardInfo(standardInfo))
                .called(1),
      );
    });

    group('InterestsEdited', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository editInterests',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) =>
            bloc.add(InterestsEdited(interests: interests, private: true)),
        verify: (_) => verify(
          () =>
              userRepository.editInterests(interests: interests, private: true),
        ).called(1),
      );
    });

    group('BioEdited', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository editBio',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(BioEdited(bio: bio, private: true)),
        verify: (_) => verify(
          () => userRepository.editBio(bio: bio, private: true),
        ).called(1),
      );
    });

    group('PicAdded', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository addPic',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(PicAdded(pic: pic, private: true)),
        verify: (_) => verify(
          () => userRepository.addPic(pic: pic, private: true),
        ).called(1),
      );
    });

    group('PicDeleted', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository deletePic',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(PicDeleted(picId: picId, private: true)),
        verify: (_) => verify(
          () => userRepository.deletePic(picId: picId, private: true),
        ).called(1),
      );
    });

    group('SexAndOrientationEdited', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository editSexAndOrientation',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          SexAndOrientationEdited(
            sex: PrivateData(sex, private: true),
            searching: PrivateData(searching, private: true),
          ),
        ),
        verify: (_) => verify(
          () => userRepository.editSexAndOrientation(
            sex: sex,
            isSexPrivate: true,
            searching: searching,
            isSearchingPrivate: true,
          ),
        ).called(1),
      );
    });

    group('LocationEdited', () {
      blocTest<ProfileBloc, ProfileState>(
        'call userRepository editLocation',
        build: () => ProfileBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(
          LocationEdited(
            longitude: longitude,
            latitude: latitude,
            private: true,
          ),
        ),
        verify: (_) => verify(
          () => userRepository.editLocation(
            longitude: longitude,
            latitude: latitude,
            private: true,
          ),
        ).called(1),
      );
    });
  });
}

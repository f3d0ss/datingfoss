import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockDiscoverRepository extends Mock implements DiscoverRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockLocalUser extends Mock implements LocalUser {}

class MockAddLikeMessage extends Mock implements AddLikeMessage {}

class MockRemoveLikeMessage extends Mock implements RemoveLikeMessage {}

void main() {
  group('DiscoverBloc', () {
    late UserRepository userRepository;
    late DiscoverRepository discoverRepository;
    late LocalUser localUser;
    late AddLikeMessage addLikeMessageFromLocalUser;
    late AddLikeMessage addLikeMessageFromPartner;
    late RemoveLikeMessage removeLikeMessageFromLocalUser;
    late RemoveLikeMessage removeLikeMessageFromPartner;
    late String partnerUsername;
    late List<String> partnerKeys;
    late StreamController<AddLikeMessage> receivedLikeStream;
    late StreamController<AddLikeMessage> sendedLikeStream;
    late StreamController<RemoveLikeMessage> receivedRemoveLikeStream;
    late StreamController<RemoveLikeMessage> sendedRemoveLikeStream;
    setUp(() {
      userRepository = MockUserRepository();
      discoverRepository = MockDiscoverRepository();
      addLikeMessageFromPartner = MockAddLikeMessage();
      addLikeMessageFromLocalUser = MockAddLikeMessage();
      removeLikeMessageFromLocalUser = MockRemoveLikeMessage();
      removeLikeMessageFromPartner = MockRemoveLikeMessage();
      localUser = MockLocalUser();
      partnerUsername = 'bob';
      partnerKeys = ['key1'];
      receivedLikeStream = StreamController<AddLikeMessage>.broadcast();
      sendedLikeStream = StreamController<AddLikeMessage>.broadcast();
      receivedRemoveLikeStream =
          StreamController<RemoveLikeMessage>.broadcast();
      sendedRemoveLikeStream = StreamController<RemoveLikeMessage>.broadcast();
      when(() => localUser.username).thenReturn('rob');
      when(() => addLikeMessageFromPartner.username)
          .thenReturn(partnerUsername);
      when(() => addLikeMessageFromPartner.keys).thenReturn(partnerKeys);
      when(() => addLikeMessageFromLocalUser.username)
          .thenReturn(partnerUsername);
      when(() => addLikeMessageFromLocalUser.keys).thenReturn(partnerKeys);
      when(() => removeLikeMessageFromPartner.username)
          .thenReturn(partnerUsername);
      when(() => removeLikeMessageFromLocalUser.username)
          .thenReturn(partnerUsername);

      when(() => discoverRepository.receivedLike).thenAnswer(
        (_) => receivedLikeStream.stream,
      );
      when(() => discoverRepository.sendedLike).thenAnswer(
        (_) => sendedLikeStream.stream,
      );
      when(() => discoverRepository.receivedRemoveLike).thenAnswer(
        (_) => receivedRemoveLikeStream.stream,
      );
      when(() => discoverRepository.sendedRemoveLike).thenAnswer(
        (_) => sendedRemoveLikeStream.stream,
      );
      when(() => userRepository.currentUser).thenReturn(localUser);
    });

    test('initial state is an empty MatchState', () {
      expect(
        MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ).state,
        const MatchState(),
      );
    });

    group('when event arrive from repository', () {
      test('received like trigger a PartnerAddedLike', () async {
        final matchBloc = MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        );
        receivedLikeStream.add(addLikeMessageFromPartner);
        await expectLater(
          matchBloc.stream,
          emits(MatchState(partnerThatLikeMe: {partnerUsername: partnerKeys})),
        );
      });
      test('send like trigger a UserAddedLike', () async {
        final matchBloc = MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        );
        sendedLikeStream.add(addLikeMessageFromLocalUser);
        await expectLater(
          matchBloc.stream,
          emits(MatchState(partnerThatILike: {partnerUsername: partnerKeys})),
        );
      });
      test('receive remove like trigger a PartnerRemovedLike', () async {
        final matchBloc = MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        )..emit(MatchState(partnerThatLikeMe: {partnerUsername: partnerKeys}));
        receivedRemoveLikeStream.add(removeLikeMessageFromPartner);
        await expectLater(matchBloc.stream, emits(const MatchState()));
      });
      test('send remove like trigger a UserRemovedLike', () async {
        final matchBloc = MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        )..emit(MatchState(partnerThatILike: {partnerUsername: partnerKeys}));
        sendedRemoveLikeStream.add(removeLikeMessageFromLocalUser);
        await expectLater(matchBloc.stream, emits(const MatchState()));
      });
    });
    group('PartnerAddedLike', () {
      blocTest<MatchBloc, MatchState>(
        'add the partner to partnerThatLikeMe and emit match',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () =>
            MatchState(partnerThatILike: {partnerUsername: partnerKeys}),
        act: (bloc) => bloc.add(PartnerAddedLike(addLikeMessageFromPartner)),
        expect: () => [
          MatchState(
            partnerThatILike: {partnerUsername: partnerKeys},
            partnerThatLikeMe: {partnerUsername: partnerKeys},
            newMatch: addLikeMessageFromPartner,
          )
        ],
      );
    });

    group('UserAddedLike', () {
      blocTest<MatchBloc, MatchState>(
        'add the partner to partnerThatILike',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () =>
            MatchState(partnerThatLikeMe: {partnerUsername: partnerKeys}),
        act: (bloc) => bloc.add(UserAddedLike(addLikeMessageFromLocalUser)),
        expect: () => [
          MatchState(
            partnerThatILike: {partnerUsername: partnerKeys},
            partnerThatLikeMe: {partnerUsername: partnerKeys},
            newMatch: addLikeMessageFromLocalUser,
          )
        ],
      );
    });

    group('PartnerRemovedLike', () {
      blocTest<MatchBloc, MatchState>(
        'remove the partner from partnerThatLikeMe',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () => MatchState(
          partnerThatLikeMe: {partnerUsername: partnerKeys},
          partnerThatILike: {partnerUsername: partnerKeys},
        ),
        act: (bloc) =>
            bloc.add(PartnerRemovedLike(removeLikeMessageFromPartner)),
        expect: () => [
          MatchState(
            partnerThatILike: {partnerUsername: partnerKeys},
            undoMatch: partnerUsername,
          ),
          MatchState(partnerThatILike: {partnerUsername: partnerKeys})
        ],
      );
    });

    group('UserRemovedLike', () {
      blocTest<MatchBloc, MatchState>(
        'remove the partner from partnerThatILike',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () => MatchState(
          partnerThatILike: {partnerUsername: partnerKeys},
          partnerThatLikeMe: {partnerUsername: partnerKeys},
        ),
        act: (bloc) =>
            bloc.add(UserRemovedLike(removeLikeMessageFromLocalUser)),
        expect: () => [
          MatchState(
            partnerThatLikeMe: {partnerUsername: partnerKeys},
            undoMatch: partnerUsername,
          ),
          MatchState(partnerThatLikeMe: {partnerUsername: partnerKeys})
        ],
      );
    });

    group('TappedNewMatch', () {
      blocTest<MatchBloc, MatchState>(
        'remove the newMatch',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () => MatchState(newMatch: addLikeMessageFromPartner),
        act: (bloc) => bloc.add(TappedNewMatch()),
        expect: () => [const MatchState()],
      );
    });

    group('TappedNewMatch', () {
      blocTest<MatchBloc, MatchState>(
        'remove the newMatch',
        build: () => MatchBloc(
          userRepository: userRepository,
          discoverRepository: discoverRepository,
        ),
        seed: () => MatchState(newMatch: addLikeMessageFromPartner),
        act: (bloc) => bloc.add(TappedNewMatch()),
        expect: () => [const MatchState()],
      );
    });
    // group('PageChangedToChat', () {
    //   blocTest<MainBloc, MainState>(
    //     'emits state with chat as mainPage',
    //     build: MainBloc.new,
    //     act: (bloc) => bloc.add(PageChangedToChat()),
    //     expect: () => [MainState(mainPage: MainPage.chat)],
    //   );
    // });
    // group('PageChangedToProfile', () {
    //   blocTest<MainBloc, MainState>(
    //     'emits state with profile as mainPage',
    //     build: MainBloc.new,
    //     act: (bloc) => bloc.add(PageChangedToProfile()),
    //     expect: () => [MainState(mainPage: MainPage.profile)],
    //   );
    // });
  });
}

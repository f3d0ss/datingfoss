import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cache/cache.dart';
import 'package:controllers/controllers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/discover/default_discover_repository.dart';
import 'package:services/services.dart';
import 'package:test/test.dart';

class MockDiscoverController extends Mock implements DiscoverController {}

class MockAsymmetricEncryptionService extends Mock
    implements AsymmetricEncryptionService {}

class MockSymmetricEncryptionService extends Mock
    implements SymmetricEncryptionService {}

class MockCacheClient extends Mock implements CacheClient {}

class MockNotificationService extends Mock implements NotificationService {}

class MockPartner extends Mock implements Partner {}

class MockUserDTO extends Mock implements UserDTO {}

void main() {
  group('DiscoverRepository', () {
    late DiscoverController discoverController;
    late AsymmetricEncryptionService asymmetricEncryptionService;
    late SymmetricEncryptionService symmetricEncryptionService;
    late CacheClient cacheClient;
    late NotificationService notificationService;
    late String directoryToStoreFiles;
    setUpAll(() {
      discoverController = MockDiscoverController();
      asymmetricEncryptionService = MockAsymmetricEncryptionService();
      symmetricEncryptionService = MockSymmetricEncryptionService();
      cacheClient = MockCacheClient();
      notificationService = MockNotificationService();
      directoryToStoreFiles = 'tempDir/';
    });
    test('can be instantiated', () {
      expect(
        DiscoverRepositoryImplementation(
          discoverController: discoverController,
          asymmetricEncryptionService: asymmetricEncryptionService,
          symmetricEncryptionService: symmetricEncryptionService,
          cacheClient: cacheClient,
          notificationService: notificationService,
          directoryToStoreFiles: directoryToStoreFiles,
        ),
        isNotNull,
      );
    });

    group('with instantiated DiscoverRepositoryImplementation', () {
      late DiscoverRepository discoverRepository;
      late String authenticatedUsername;
      late int numberOfPartnerToFetch;
      const repositoryFetchEachRound = 2;
      late UserDTO aliceDTO;
      late Partner alice;
      late UserDTO bobDTO;
      late List<int> signature;
      late String alicePublicPicId;
      late File alicePublicPic;
      late String alicePrivatePicId;
      late File aliceEncPrivPic;
      late String alicePrivatePicKey;
      late File aliceDecryptedPrivPic;
      late StreamController<NotificationDTO> streamControllerNotificaitonDTO;

      setUp(() {
        authenticatedUsername = 'mark88';
        discoverRepository = DiscoverRepositoryImplementation(
          discoverController: discoverController,
          asymmetricEncryptionService: asymmetricEncryptionService,
          symmetricEncryptionService: symmetricEncryptionService,
          cacheClient: cacheClient,
          notificationService: notificationService,
          directoryToStoreFiles: directoryToStoreFiles,
        );
        numberOfPartnerToFetch = 10;

        signature = [];
        alicePublicPicId = 'alicePicId';
        alicePublicPic = File('');
        alicePrivatePicId = 'alicePrivatePicId';
        aliceEncPrivPic = File('');
        alicePrivatePicKey = 'alicePrivatePicKey';
        aliceDecryptedPrivPic = File('');
        aliceDTO = const UserDTO(
          username: 'alice',
          publicInfo: PublicInfoDTO(
            location: LocationDTO(0, 0),
            searching: RangeValuesDTO(0, 1),
          ),
          privateInfo: PrivateInfoDTO(),
          publicKey: <String, dynamic>{},
        );
        alice = Partner(
          username: 'alice',
          publicInfo: PublicInfo(pictures: [alicePublicPicId]),
          privateInfo: PrivateInfo(
            pictures: [PrivatePic(picId: alicePrivatePicId, keyIndex: 0)],
          ),
          jsonPublicKey: const <String, dynamic>{},
        );
        bobDTO = const UserDTO(
          username: 'bob',
          publicInfo: PublicInfoDTO(),
          privateInfo: PrivateInfoDTO(),
          publicKey: <String, dynamic>{},
        );
        streamControllerNotificaitonDTO = StreamController();

        when(() => symmetricEncryptionService.loadedKeys)
            .thenReturn(['thisIsAKey']);
        when(
          () => discoverController.sendSealedLikeMessage(
            to: alice.username,
            sealedLikeMessage: any(named: 'sealedLikeMessage'),
          ),
        ).thenAnswer((_) async {});
        when(
          () => discoverController.fetchPartners(
            numberOfPartner: repositoryFetchEachRound,
            alreadyFetchedUsers: any(named: 'alreadyFetchedUsers'),
          ),
        ).thenAnswer((_) async => [aliceDTO, bobDTO]);
        when(
          () => discoverController.fetchPartner(
            username: any(named: 'username'),
          ),
        ).thenAnswer((_) async => aliceDTO);
        when(
          () => discoverController.fetchPartnerPublicPicture(
            username: alice.username,
            id: alicePublicPicId,
          ),
        ).thenAnswer((_) async => alicePublicPic);
        when(
          () => discoverController.fetchPartnerEncryptedPrivatePicture(
            username: alice.username,
            id: alicePrivatePicId,
          ),
        ).thenAnswer((_) async => aliceEncPrivPic);

        when(() => asymmetricEncryptionService.sign(any()))
            .thenAnswer((_) async => signature);
        when(() => asymmetricEncryptionService.encrypt(any(), any()))
            .thenAnswer((_) async => signature);
        when(
          () => symmetricEncryptionService.decryptFile(
            inputFile: aliceEncPrivPic,
            username: alice.username,
            newFilePath: '$directoryToStoreFiles/private/$alicePrivatePicId',
            base64Key: alicePrivatePicKey,
          ),
        ).thenAnswer((_) async => aliceDecryptedPrivPic);

        when(() => notificationService.notifications)
            .thenAnswer((_) => streamControllerNotificaitonDTO.stream);
      });
      test('can fetch', () {
        discoverRepository.fetch(
          numberOfPartners: numberOfPartnerToFetch,
          userToKeys: {
            aliceDTO.username: ['key']
          },
        );
      });

      test('can fetchPartner', () {
        discoverRepository.fetchPartner(username: alice.username);
      });

      test('can putLike', () {
        discoverRepository.putLike(
          partner: alice,
          fromUsername: authenticatedUsername,
        );
      });

      test('can removeLike', () {
        discoverRepository.removeLike(
          partner: alice,
          fromUsername: authenticatedUsername,
        );
      });

      test('can fetchPublicImage', () {
        discoverRepository.fetchPublicImage(
          username: alice.username,
          id: alicePublicPicId,
        );
      });

      test('can fetchPrivateImage', () {
        discoverRepository.fetchPrivateImage(
          username: alice.username,
          id: alicePrivatePicId,
          base64Key: alicePrivatePicKey,
        );
      });

      test('can getPicturesFromCache', () {
        discoverRepository.getPicturesFromCache(partner: alice);
      });

      test('can subscribeToLikeMessages', () {
        discoverRepository.subscribeToLikeMessages(
          username: authenticatedUsername,
        );
      });

      test('can get streams', () {
        expect(discoverRepository.possiblePartners, isA<Stream<Partner>>());
        expect(discoverRepository.sendedLike, isA<Stream<AddLikeMessage>>());
        expect(
          discoverRepository.sendedRemoveLike,
          isA<Stream<RemoveLikeMessage>>(),
        );
      });

      group('when a notification arrive', () {
        late Map<String, dynamic> notificationContent;
        late List<int> notificationEncContent;
        late int notificationLikeMessageType;
        late PackedLikeMessage packedLikeMessage;
        late LikeMessage likeMessage;
        late List<int> signedPartnerUsername;
        setUp(() {
          notificationLikeMessageType = 1;
          discoverRepository.subscribeToLikeMessages(
            username: authenticatedUsername,
          );
          notificationEncContent = [];
          notificationContent = <String, dynamic>{
            'content': base64.encode(notificationEncContent)
          };
          signedPartnerUsername = [];

          when(
            () => discoverController.fetchPublicKey(username: alice.username),
          ).thenAnswer((_) async => alice.jsonPublicKey);
          when(
            () => asymmetricEncryptionService.verifySignature(
              alice.jsonPublicKey,
              authenticatedUsername,
              signedPartnerUsername,
            ),
          ).thenReturn(true);
        });

        group('with like message', () {
          setUp(() {
            likeMessage =
                AddLikeMessage(username: alice.username, keys: const []);
            packedLikeMessage = PackedLikeMessage(
              likeMessage: likeMessage.toJson(),
              type: LikeMessageType.addLike.toString(),
              signedPartnerUsername: signedPartnerUsername,
            );
            when(
              () => asymmetricEncryptionService.decrypt(notificationEncContent),
            ).thenAnswer((_) async => json.encode(packedLikeMessage));
          });
          test('add like message', () {
            discoverRepository.receivedLike.listen((event) {
              expect(true, true);
            });
            streamControllerNotificaitonDTO.add(
              NotificationDTO(
                type: notificationLikeMessageType,
                content: notificationContent,
              ),
            );
          });
        });
        group('with remove like message', () {
          setUp(() {
            likeMessage = RemoveLikeMessage(username: alice.username);
            packedLikeMessage = PackedLikeMessage(
              likeMessage: likeMessage.toJson(),
              type: LikeMessageType.removeLike.toString(),
              signedPartnerUsername: signedPartnerUsername,
            );
            when(
              () => asymmetricEncryptionService.decrypt(notificationEncContent),
            ).thenAnswer((_) async => json.encode(packedLikeMessage));
          });
          test('add remove like', () {
            discoverRepository.receivedRemoveLike.listen((event) {
              expect(true, true);
            });
            streamControllerNotificaitonDTO.add(
              NotificationDTO(
                type: notificationLikeMessageType,
                content: notificationContent,
              ),
            );
          });
        });
      });
    });
  });
}

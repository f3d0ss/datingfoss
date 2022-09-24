import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cache/cache.dart';
import 'package:controllers/controllers.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/user/default_user_repository.dart';
import 'package:services/services.dart';
import 'package:test/test.dart';

class MockUserController extends Mock implements UserController {}

class MockAuthenticationController extends Mock
    implements AuthenticationController {}

class MockAsymmetricEncryptionService extends Mock
    implements AsymmetricEncryptionService {}

class MockSymmetricEncryptionService extends Mock
    implements SymmetricEncryptionService {}

class MockCacheClient extends Mock implements CacheClient {}

class MockNotificationService extends Mock implements NotificationService {}

class MockPartner extends Mock implements Partner {}

class MockUserDTO extends Mock implements UserDTO {}

void main() {
  group('UserRepository', () {
    late UserController userController;
    late AuthenticationController authenticationController;
    late AsymmetricEncryptionService asymmetricEncryptionService;
    late SymmetricEncryptionService symmetricEncryptionService;
    late NotificationService notificationService;
    late String directoryToStoreFile;
    late StreamController<NotificationDTO> streamControllerNotificaitonDTO;
    setUpAll(() {
      registerFallbackValue(
        const UserDTO(
          username: '',
          publicInfo: PublicInfoDTO(),
          privateInfo: PrivateInfoDTO(),
          publicKey: <String, dynamic>{},
        ),
      );
      registerFallbackValue(File(''));
    });
    setUp(() {
      userController = MockUserController();
      authenticationController = MockAuthenticationController();
      asymmetricEncryptionService = MockAsymmetricEncryptionService();
      symmetricEncryptionService = MockSymmetricEncryptionService();
      notificationService = MockNotificationService();
      directoryToStoreFile = 'dir';
      streamControllerNotificaitonDTO = StreamController();
      when(() => notificationService.notifications)
          .thenAnswer((_) => streamControllerNotificaitonDTO.stream);
    });
    test('can be instantiated', () {
      expect(
        DefaultUserRepository(
          userController: userController,
          authenticationController: authenticationController,
          asymmetricEncryptionService: asymmetricEncryptionService,
          symmetricEncryptionService: symmetricEncryptionService,
          notificationService: notificationService,
          directoryToStoreFiles: directoryToStoreFile,
        ),
        isNotNull,
      );
    });

    group('with instantiated DefaultUserRepository', () {
      late UserRepository userRepository;
      late LocalSignupUser alice;
      late UserDTO aliceDTO;
      late Map<String, dynamic> jsonPublicKey;
      late List<String> loadedKeys;
      late List<int> encryptedSymmetricKeys;
      late String dataToSign;
      late List<int> dataSigned;
      late TokenDTO tokenDTO;
      late File publicPic;
      late File privateEncryptedPic;
      late File privateDencryptedPic;

      setUp(() async {
        userRepository = DefaultUserRepository(
          userController: userController,
          authenticationController: authenticationController,
          asymmetricEncryptionService: asymmetricEncryptionService,
          symmetricEncryptionService: symmetricEncryptionService,
          notificationService: notificationService,
          directoryToStoreFiles: directoryToStoreFile,
        );
        publicPic = File('test/assets/publicPic');
        await publicPic.create(recursive: true);
        privateEncryptedPic = File('test/assets/privateEncryptedPic');
        await privateEncryptedPic.create();
        privateDencryptedPic = File('test/assets/privateDencryptedPic');
        await privateDencryptedPic.create();

        alice = LocalSignupUser(
          username: 'alice',
          password: 'password',
          pictures: [publicPic],
          privatePictures: [privateDencryptedPic],
        );

        jsonPublicKey = <String, dynamic>{};
        loadedKeys = [''];
        encryptedSymmetricKeys = [];
        dataToSign = 'dataToSign';
        tokenDTO = TokenDTO(
          Challenge(dataToSign, alice.username!, 'exp'),
          'serverSignedToken',
        );
        dataSigned = [];

        when(
          () => asymmetricEncryptionService.createKeyPair(
            alice.username!,
            alice.password!,
          ),
        ).thenAnswer((_) async {});
        when(
          () => authenticationController.signUp(
            username: alice.username!,
            publicKey: jsonPublicKey,
          ),
        ).thenAnswer((_) async {});
        when(
          () => authenticationController.getLoginChallenge(
            username: alice.username!,
          ),
        ).thenAnswer((_) async => tokenDTO);
        when(
          () => authenticationController.logIn(
            username: alice.username!,
            token: tokenDTO,
            signedChallenge: dataSigned,
          ),
        ).thenAnswer((_) async {});
        when(
          () => authenticationController.doesUserExist(alice.username!),
        ).thenAnswer((_) async => true);
        when(() => asymmetricEncryptionService.sign(dataToSign))
            .thenAnswer((_) async => dataSigned);
        when(
          () => asymmetricEncryptionService
              .encryptWithLoadedKey(json.encode(loadedKeys)),
        ).thenAnswer((_) async => encryptedSymmetricKeys);
        when(
          () => asymmetricEncryptionService.decrypt(encryptedSymmetricKeys),
        ).thenAnswer((_) async => json.encode(loadedKeys));
        when(() => asymmetricEncryptionService.jsonPublicKey)
            .thenReturn(jsonPublicKey);
        when(() => symmetricEncryptionService.loadedKeys)
            .thenReturn(loadedKeys);
        when(
          () => symmetricEncryptionService.encryptWithLastKey(
            plainText: any(named: 'plainText'),
            username: alice.username!,
          ),
        ).thenAnswer(
          (invocation) =>
              invocation.namedArguments[const Symbol('plainText')] as String,
        );
        when(
          () => symmetricEncryptionService.encryptFile(
            inputFile: any(named: 'inputFile'),
            username: alice.username!,
            newFilePath: any(named: 'newFilePath'),
          ),
        ).thenAnswer((_) async => privateEncryptedPic);
        when(
          () => symmetricEncryptionService.decryptFileWithLoadedKey(
            inputFile: privateEncryptedPic,
            username: alice.username!,
            newFilePath: any(named: 'newFilePath'),
            keyIndex: any(named: 'keyIndex'),
          ),
        ).thenAnswer((_) async => privateDencryptedPic);
        when(
          () => symmetricEncryptionService.decrypt(
            base64Encoded: any(named: 'base64Encoded'),
            base64Key: any(named: 'base64Key'),
            username: alice.username!,
          ),
        ).thenAnswer((invocation) {
          final encode = invocation
              .namedArguments[const Symbol('base64Encoded')]! as String;
          if (encode == '{}') return json.encode(<Map, dynamic>{});
          if (encode == '""') return json.encode('');
          if (encode == '[]') return json.encode(<dynamic>[]);
          return '';
        });
        when(() => symmetricEncryptionService.lastKeyIndex).thenReturn(0);

        // aliceDTO = await alice.toUserDTO(
        //   asymmetricEncryptionService: asymmetricEncryptionService,
        //   symmetricEncryptionService: symmetricEncryptionService,
        // );
        aliceDTO = UserDTO(
          username: alice.username!,
          publicInfo: const PublicInfoDTO(pictures: ['p']),
          privateInfo: const PrivateInfoDTO(
            pictures: [PrivatePictureDTO(id: 'p', key: 0)],
          ),
          publicKey: jsonPublicKey,
        );

        when(
          () => userController.pushUser(any()),
        ).thenAnswer((_) async {});
        when(
          () => userController.fetchUser(),
        ).thenAnswer((_) async => aliceDTO);
        when(
          () => userController.pushPublicPic(any()),
        ).thenAnswer((_) async => 'p');
        when(
          () => userController.fetchPublicPics(
            aliceDTO.publicInfo.pictures,
            aliceDTO.username,
          ),
        ).thenAnswer((_) async => [publicPic]);
        when(
          () => userController.fetchEncryptedPrivatePics(
            any(),
            aliceDTO.username,
          ),
        ).thenAnswer((_) async => [privateEncryptedPic]);
        when(
          () => userController.pushEncryptedPrivatePic(any(), 0),
        ).thenAnswer((_) async => 'p');

        when(
          () => userController.pushSymmetricEncryptedKeys(
            base64.encode(encryptedSymmetricKeys),
          ),
        ).thenAnswer((_) async {});
        when(
          () => userController.fetchSymmetricEncryptedKeys(),
        ).thenAnswer((_) async => base64.encode(encryptedSymmetricKeys));
      });

      test('can get currentUser', () {
        expect(userRepository.currentUser, LocalUser.empty);
      });

      test('can signUp', () {
        userRepository.signUp(signupUser: alice);
      });

      test('can logInWithUsernameAndPassword', () {
        userRepository.logInWithUsernameAndPassword(
          username: alice.username!,
          password: alice.password!,
        );
      });

      test('can isUsernameAvailable', () {
        userRepository.isUsernameAvailable(alice.username!);
      });

      test('can get user streams', () {
        expect(userRepository.user, isA<Stream<LocalUser>>());
      });

      group('with a logged user', () {
        late StandardInfo standardInfo;
        late List<String> interests;
        late String bio;
        late double sex;
        late RangeValues searching;
        late double latitude;
        late double longitude;

        setUp(() async {
          await userRepository.signUp(signupUser: alice);
          standardInfo =
              const StandardInfo(textInfo: {}, dateInfo: {}, boolInfo: {});
          interests = ['a'];
          bio = 'bio';
          sex = 0;
          searching = const RangeValues(0, 1);
          latitude = 0;
          longitude = 0;
          publicPic = File('test/assets/publicPic');
          await publicPic.create(recursive: true);
          privateEncryptedPic = File('test/assets/privateEncryptedPic');
          await privateEncryptedPic.create();
          privateDencryptedPic = File('test/assets/privateDencryptedPic');
          await privateDencryptedPic.create();
          when(() => authenticationController.logOut())
              .thenAnswer((_) async {});
        });
        test('can logOut', () {
          userRepository.logOut();
        });

        test('can editStandardInfo', () {
          userRepository.editStandardInfo(standardInfo);
        });

        test('can editInterests', () {
          userRepository
            ..editInterests(interests: interests, private: false)
            ..editInterests(interests: interests, private: true);
        });

        test('can editBio', () {
          userRepository
            ..editBio(bio: bio, private: false)
            ..editBio(bio: bio, private: true);
        });

        test('can deletePic', () {
          userRepository
            ..deletePic(picId: 'picId', private: false)
            ..deletePic(picId: 'picId', private: true);
        });
        test('can addPic', () {
          userRepository
            ..addPic(pic: publicPic, private: false)
            ..addPic(pic: privateDencryptedPic, private: true);
        });

        test('can editSexAndOrientation', () {
          userRepository
            ..editSexAndOrientation(
              sex: sex,
              searching: searching,
              isSexPrivate: false,
              isSearchingPrivate: false,
            )
            ..editSexAndOrientation(
              sex: sex,
              searching: searching,
              isSexPrivate: true,
              isSearchingPrivate: true,
            );
        });

        test('can editLocation', () {
          userRepository
            ..editLocation(
              latitude: latitude,
              longitude: longitude,
              private: false,
            )
            ..editLocation(
              latitude: latitude,
              longitude: longitude,
              private: true,
            );
        });
      });
    });
  });
}

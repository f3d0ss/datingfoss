// ignore_for_file: implementation_imports

import 'package:cache/cache.dart';
import 'package:communication_handler/src/dio_client.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/rest_authentication_controller.dart';
import 'package:controllers/src/rest_discover_controller.dart';
import 'package:controllers/src/rest_user_controller.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/discover/default_discover_repository.dart';
import 'package:repositories/src/user/default_user_repository.dart';
import 'package:services/services.dart';

class MockNotificationService extends Mock implements NotificationService {}

class MockUserGenerator {
  MockUserGenerator(
    this.localSignupUser,
    String baseURL, {
    required String basePath,
  }) : _directoryToStoreFile = '${basePath}tmp/' {
    communicationHandler = DioClient(baseURL: baseURL);
    authenticationController = RestAuthenticationController(
      communicationHandler: communicationHandler,
    );
    userController = RestUserController(
      communicationHandler: communicationHandler,
      directoryToStoreFiles: _directoryToStoreFile,
    );

    userRepository = DefaultUserRepository(
      asymmetricEncryptionService: asymmetricEncryptionService,
      symmetricEncryptionService: symmetricEncryptionService,
      authenticationController: authenticationController,
      userController: userController,
      notificationService: notificationService,
      directoryToStoreFiles: _directoryToStoreFile,
    );

    discoverController = RestDiscoverController(
      communicationHandler: communicationHandler,
      directoryToStoreFiles: _directoryToStoreFile,
    );

    discoverRepository = DiscoverRepositoryImplementation(
      asymmetricEncryptionService: asymmetricEncryptionService,
      cacheClient: CacheClient(),
      directoryToStoreFiles: _directoryToStoreFile,
      discoverController: discoverController,
      symmetricEncryptionService: symmetricEncryptionService,
      notificationService: notificationService,
    );
  }

  final LocalSignupUser localSignupUser;
  final String _directoryToStoreFile;

  late DioClient communicationHandler;

  final asymmetricEncryptionService = RSAEncryptionService();
  final symmetricEncryptionService = AESEncryptionService();
  final notificationService = MockNotificationService();

  late RestAuthenticationController authenticationController;
  late RestUserController userController;
  late DiscoverController discoverController;

  late DefaultUserRepository userRepository;
  late DiscoverRepositoryImplementation discoverRepository;

  bool signedUp = false;

  Future<void> signUp() async {
    await userRepository.signUp(signupUser: localSignupUser);
    signedUp = true;
  }

  Future<UserDTO> toUserDTO() async => localSignupUser.toUserDTO(
        asymmetricEncryptionService: asymmetricEncryptionService,
        symmetricEncryptionService: symmetricEncryptionService,
      );

  Future<void> putLike(Partner partner) async => discoverRepository.putLike(
        partner: partner,
        fromUsername: localSignupUser.username!,
      );

  LocalUser toLocalUser() => localSignupUser.toLocalUser();

  Partner toPartner() {
    if (!signedUp) {
      asymmetricEncryptionService.createKeyPair(
        localSignupUser.username!,
        localSignupUser.password!,
      );
    }
    return Partner(
      username: localSignupUser.toLocalUser().username,
      publicInfo: localSignupUser.toLocalUser().publicInfo,
      jsonPublicKey: asymmetricEncryptionService.jsonPublicKey,
    );
  }
}

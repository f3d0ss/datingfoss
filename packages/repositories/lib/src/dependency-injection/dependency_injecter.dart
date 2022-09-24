import 'dart:io';

import 'package:cache/cache.dart';
import 'package:controllers/controllers.dart';
import 'package:get_it/get_it.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/chat/long_polling_chat_repository.dart';
import 'package:repositories/src/discover/default_discover_repository.dart';
import 'package:repositories/src/user/default_user_repository.dart';
import 'package:services/services.dart';

extension GetItExtensions on GetIt {
  void useRepositories({
    bool mockAuthenticatedUser = false,
    bool mockDiscoverController = false,
    bool mockChatController = false,
    bool mockNotificationsController = false,
    required String directoryToStoreFiles,
    required Future<File> Function(String) getImageFileFromAssets,
  }) {
    useControllerServices(
      mockDiscoverController: mockDiscoverController,
      mockAuthenticatedUser: mockAuthenticatedUser,
      mockChatController: mockChatController,
      mockNotificationsController: mockNotificationsController,
      directoryToStoreFiles: directoryToStoreFiles,
      getImageFileFromAssets: getImageFileFromAssets,
    );
    useServices(mockAsymmetricEncryption: mockAuthenticatedUser);
    registerFactory<CacheClient>(CacheClient.new);

    registerLazySingleton<ChatRepository>(
      () => LongPollingChatRepository(
        chatController: this(),
        notificationRepository: this(),
      ),
    );
    registerLazySingleton<UserRepository>(
      () => DefaultUserRepository(
        authenticationController: this(),
        userController: this(),
        asymmetricEncryptionService: this(),
        symmetricEncryptionService: this(),
        notificationService: this(),
        directoryToStoreFiles: directoryToStoreFiles,
      ),
    );
    registerLazySingleton<DiscoverRepository>(
      () => DiscoverRepositoryImplementation(
        discoverController: this(),
        asymmetricEncryptionService: this(),
        symmetricEncryptionService: this(),
        cacheClient: this(),
        notificationService: this(),
        directoryToStoreFiles: directoryToStoreFiles,
      ),
    );
  }
}

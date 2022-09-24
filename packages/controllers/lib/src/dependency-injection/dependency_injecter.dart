import 'dart:io';

import 'package:communication_handler/communication_handler.dart';
import 'package:controllers/controllers.dart';
import 'package:controllers/src/mock_authentication_controller.dart';
import 'package:controllers/src/mock_chat_controller.dart';
import 'package:controllers/src/mock_notifications_controller.dart';
import 'package:controllers/src/mock_rest_discover_controller.dart';
import 'package:controllers/src/rest_authentication_controller.dart';
import 'package:controllers/src/rest_chat_controller.dart';
import 'package:controllers/src/rest_discover_controller.dart';
import 'package:controllers/src/rest_notifications_controller.dart';
import 'package:controllers/src/rest_user_controller.dart';
import 'package:get_it/get_it.dart';

extension GetItExtensions on GetIt {
  void useControllerServices({
    bool mockDiscoverController = false,
    bool mockAuthenticatedUser = false,
    bool mockChatController = false,
    bool mockNotificationsController = false,
    required String directoryToStoreFiles,
    required Future<File> Function(String) getImageFileFromAssets,
  }) {
    useCommunicationHandlerServices();
    registerLazySingleton<AuthenticationController>(
      () => mockAuthenticatedUser
          ? MockAuthenticationController(communicationHandler: this())
          : RestAuthenticationController(communicationHandler: this()),
    );
    registerLazySingleton<DiscoverController>(
      () => mockDiscoverController
          ? MockRestDiscoverController(
              directoryToStoreFiles: directoryToStoreFiles,
            )
          : RestDiscoverController(
              communicationHandler: this(),
              directoryToStoreFiles: directoryToStoreFiles,
            ),
    );
    registerLazySingleton<UserController>(
      () => RestUserController(
        communicationHandler: this(),
        directoryToStoreFiles: directoryToStoreFiles,
      ),
    );
    registerLazySingleton<ChatController>(
      () => mockChatController
          ? MockChatController()
          : RestChatController(communicationHandler: this()),
    );
    registerLazySingleton<NotificationsController>(
      () => mockNotificationsController
          ? MockNotificationsController()
          : RestNotificationsController(communicationHandler: this()),
    );
  }
}

// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'dart:io';

import 'package:controllers/controllers.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

void main() {
  group('Dependenct Injection', () {
    tearDown(() {
      GetIt.I.reset();
    });
    test('can inject rest implementation', () {
      GetIt.I.useControllerServices(
        directoryToStoreFiles: '',
        getImageFileFromAssets: (_) async => File(''),
      );
      final AuthenticationController authenticationController = GetIt.I();
      final DiscoverController discoverController = GetIt.I();
      final UserController userController = GetIt.I();
      final ChatController chatController = GetIt.I();
      final NotificationsController notificationsController = GetIt.I();
    });

    test('can inject rest mock', () {
      GetIt.I.useControllerServices(
        mockAuthenticatedUser: true,
        mockChatController: true,
        mockDiscoverController: true,
        mockNotificationsController: true,
        directoryToStoreFiles: '',
        getImageFileFromAssets: (_) async => File(''),
      );
      final AuthenticationController authenticationController = GetIt.I();
      final DiscoverController discoverController = GetIt.I();
      final UserController userController = GetIt.I();
      final ChatController chatController = GetIt.I();
      final NotificationsController notificationsController = GetIt.I();
    });
  });
}

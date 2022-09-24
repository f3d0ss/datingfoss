// ignore_for_file: omit_local_variable_types, unused_local_variable
import 'package:controllers/controllers.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:services/services.dart';
import 'package:test/test.dart';

class MockNotificationsController extends Mock
    implements NotificationsController {}

void main() {
  group('Dependenct Injection', () {
    setUp(() {
      GetIt.I.registerLazySingleton<NotificationsController>(
        MockNotificationsController.new,
      );
    });

    tearDown(() {
      GetIt.I.reset();
    });
    test('can inject standard implementation', () {
      GetIt.I.useServices(mockAsymmetricEncryption: false);
      final AsymmetricEncryptionService asymmetricEncryptionService = GetIt.I();
      final SymmetricEncryptionService symmetricEncryptionService = GetIt.I();
      final NotificationService notificationService = GetIt.I();
    });

    test('can inject with mock asymmetric', () {
      GetIt.I.useServices(mockAsymmetricEncryption: true);
      final AsymmetricEncryptionService asymmetricEncryptionService = GetIt.I();
      final SymmetricEncryptionService symmetricEncryptionService = GetIt.I();
      final NotificationService notificationService = GetIt.I();
    });
  });
}

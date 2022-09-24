import 'package:get_it/get_it.dart';
import 'package:services/services.dart';
import 'package:services/src/notifications/default_notification_service.dart';

extension GetItExtensions on GetIt {
  void useServices({required bool mockAsymmetricEncryption}) {
    registerLazySingleton<AsymmetricEncryptionService>(
      () => mockAsymmetricEncryption
          ? RSAMockEncryptionService()
          : RSAEncryptionService(),
    );
    registerLazySingleton<SymmetricEncryptionService>(
      AESEncryptionService.new,
    );
    registerLazySingleton<NotificationService>(
      () => DefaultNotificationService(notificationsController: this()),
    );
  }
}

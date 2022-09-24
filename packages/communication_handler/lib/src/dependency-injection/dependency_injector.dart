import 'package:communication_handler/src/abstractions/communication_handler.dart';
import 'package:communication_handler/src/dio_client.dart';
import 'package:get_it/get_it.dart';

extension GetItExtensions on GetIt {
  void useCommunicationHandlerServices() {
    registerLazySingleton<CommunicationHandler>(DioClient.new);
  }
}

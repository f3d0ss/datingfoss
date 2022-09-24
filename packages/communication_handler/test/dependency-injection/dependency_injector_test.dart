// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:communication_handler/communication_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

void main() {
  group('Dependenct Injection', () {
    test('can inject', () {
      GetIt.I.useCommunicationHandlerServices();
      final CommunicationHandler communicationHandler = GetIt.I();
    });
  });
}

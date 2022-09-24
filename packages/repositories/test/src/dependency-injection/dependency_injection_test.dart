// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:repositories/repositories.dart';
import 'package:test/test.dart';

void main() {
  group('Dependenct Injection', () {
    test('can inject', () {
      GetIt.I.useRepositories(
        directoryToStoreFiles: '',
        getImageFileFromAssets: (_) async => File(''),
      );
      final ChatRepository chatRepository = GetIt.I();
      final UserRepository userRepository = GetIt.I();
      final DiscoverRepository discoverRepository = GetIt.I();
    });
  });
}

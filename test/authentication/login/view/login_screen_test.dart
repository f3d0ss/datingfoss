import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/authentication/login/login.dart';
import 'package:datingfoss/authentication/widgets/password_input.dart';
import 'package:datingfoss/authentication/widgets/username_input.dart';
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:repositories/repositories.dart';

Future<void> registerServices(GetIt sl) async {
  sl.useRepositories(
    mockAuthenticatedUser: true,
    mockDiscoverController: true,
    mockChatController: true,
    mockNotificationsController: true,
    directoryToStoreFiles: '',
    getImageFileFromAssets: GetFileFromAsset().getImageFileFromAssets,
  );
}

void main() {
  group('login', () {
    setUpAll(() {
      final sl = GetIt.instance;
      registerServices(sl);
      sl.registerFactory<LoginBloc>(
        () => LoginBloc(
          authenticationRepository: sl(),
        ),
      );
    });

    testWidgets('render Login', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );
      await tester.pump();
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(UsernameInput), findsOneWidget);
      expect(find.byType(PasswordInput), findsOneWidget);
      final usernameTextField = find.byType(TextField).first;
      expect(usernameTextField, isNotNull);

      final buttons = find
          .byType(ElevatedButton)
          .evaluate()
          .cast<ElevatedButton>()
          .toList();

      for (final x in buttons) {
        x.onPressed?.call();
        await tester.pump();
      }

      // await tester.enterText(usernameTextField, 'greve');
    });
  });
}

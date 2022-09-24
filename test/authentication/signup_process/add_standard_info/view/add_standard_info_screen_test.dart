import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_standard_info/add_standard_info.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
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

void registerCubits(GetIt sl) {
  sl
    ..registerFactory(AddLocationCubit.new)
    ..registerFactory(AddSexAndOrientationCubit.new)
    ..registerFactory(
      () => SignupCredentialCubit(authenticationRepository: sl()),
    )
    ..registerFactory(AddPublicPicturesCubit.new)
    ..registerFactory(AddPrivatePicturesCubit.new);
}

void main() {
  group('Add standard info', () {
    setUpAll(() {
      final sl = GetIt.instance;
      registerServices(sl);
      registerCubits(sl);
    });

    testWidgets('render AddStandardInfo and submit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddInfoScreen(),
        ),
      );
      await tester.pump();
      expect(find.byType(AddInfoScreen), findsOneWidget);
      final textField = find.byType(TextField).first;
      expect(textField, isNotNull);
      final submitButton = find.byType(SubmitButton);
      await tester.tap(submitButton);
      await tester.pump();
    });
  });
}

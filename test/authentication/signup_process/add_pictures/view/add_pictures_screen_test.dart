import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/add_pictures.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

late GetIt sl;
AddPublicPicturesCubit? addPublicPicturesCubit;

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
    ..registerFactory(() => addPublicPicturesCubit!)
    ..registerFactory(AddPrivatePicturesCubit.new);
}

List<Page<void>> onGenerateProfilePages(
  SignupFlowState signupState,
  List<Page<void>> pages,
) {
  final returnPages = <Page<void>>[
    const MaterialPage<void>(
      child: AddPictures(
        private: false,
      ),
    )
  ];
  return returnPages;
}

void main() {
  group('Add pictures', () {
    setUpAll(() {
      sl = GetIt.instance;
      registerServices(sl);
      registerCubits(sl);
    });

    Future<void> testStatus(WidgetTester tester, PicturesStatus status) async {
      addPublicPicturesCubit = AddPublicPicturesCubit();
      await tester.pumpWidget(
        const MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: SignupFlowState(),
            onGeneratePages: onGenerateProfilePages,
          ),
        ),
      );
      await tester.pump();
      addPublicPicturesCubit!.emit(AddPicturesState(status: status));
      await tester.pumpAndSettle();
    }

    testWidgets('addPicture status', (tester) async {
      await testStatus(tester, PicturesStatus.addPicture);
    });

    testWidgets('warning status 1', (tester) async {
      await testStatus(tester, PicturesStatus.warning);
      final textButton = find.byType(TextButton);
      await tester.tap(textButton.first);
      await tester.pump();
    });

    testWidgets('warning status 2', (tester) async {
      await testStatus(tester, PicturesStatus.warning);
      final textButton = find.byType(TextButton);
      await tester.tap(textButton.last);
      await tester.pump();
    });

    testWidgets('addPicture submit', (tester) async {
      await testStatus(tester, PicturesStatus.valid);
      final submitButton = find.byType(SubmitButton);
      await tester.tap(submitButton);
      await tester.pump();
    });
  });
}

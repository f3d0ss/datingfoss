import 'package:datingfoss/authentication/signup_process/add_interest/add_interest.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
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

void main() {
  group('Add interest', () {
    setUpAll(() {
      final sl = GetIt.instance;
      registerServices(sl);
      registerCubits(sl);
    });

    testWidgets('render AddInterest', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: const SignupFlowState(),
            onGeneratePages: (signupState, pages) => onGenerateProfilePages(
              signupState,
              pages,
              isPrivate: true,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AddInterest), findsOneWidget);
      final submitButton = find.byType(SubmitButton);
      await tester.tap(submitButton);
      await tester.pump();
      final dialogButton = find.byType(TextButton);
      await tester.tap(dialogButton.first);
    });
  });
}

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

List<Page<void>> onGenerateProfilePages(
  SignupFlowState signupState,
  List<Page<void>> pages, {
  bool isPrivate = false,
}) {
  final returnPages = <Page<void>>[
    MaterialPage<void>(child: AddInterest(private: isPrivate))
  ];
  return returnPages;
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/add_sex_and_orientation.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:datingfoss/widgets/select_sex_and_orientation_screen.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockAddSexAndOrientationCubit
    extends MockCubit<SelectSexAndOrientationState>
    implements AddSexAndOrientationCubit {}

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
    ..registerFactory(SelectSexAndOrientationCubit.new)
    ..registerFactory(AddPrivatePicturesCubit.new);
}

void main() {
  late GetIt sl;
  group('Add select sex and orientation', () {
    setUpAll(() {
      sl = GetIt.instance;
      registerServices(sl);
      registerCubits(sl);
    });

    testWidgets('render SelectSexAndOrientation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectSexAndOrientationScreen(
            selectSexAndOrientationCubit: sl(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SelectSexAndOrientationScreen), findsOneWidget);
      final textField = find.byType(TextField).first;
      expect(textField, isNotNull);
    });
  });

  group('AddSexAndOrientationScreen', () {
    late AddSexAndOrientationCubit addSexAndOrientationCubit;
    setUp(() async {
      addSexAndOrientationCubit = MockAddSexAndOrientationCubit();
      await GetIt.instance.reset();
      GetIt.instance.registerFactory(() => addSexAndOrientationCubit);
      when(() => addSexAndOrientationCubit.state)
          .thenReturn(const SelectSexAndOrientationState());
    });

    testWidgets('render SelectSexAndOrientation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: FlowBuilder<SignupFlowState>(
          state: SignupFlowState(),
          onGeneratePages: onGenerateProfilePages,
        ),),
      );
      await tester.pump();
      final submitButton =
          find.byType(SubmitButton).evaluate().single.widget as SubmitButton;
      submitButton.onSubmit!();
    });
  });
}

List<Page<void>> onGenerateProfilePages(
  SignupFlowState signupState,
  List<Page<void>> pages,
) {
  final returnPages = <Page<void>>[
    const MaterialPage<void>(child: SelectSexAndOrientation())
  ];
  return returnPages;
}

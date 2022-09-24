import 'package:datingfoss/authentication/signup_process/add_location/add_location.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/bloc_common/select_location_cubit/select_location_cubit.dart';
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:models/models.dart';
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
  group('Add location', () {
    setUpAll(() {
      final sl = GetIt.instance;
      registerServices(sl);
    });

    testWidgets('render AddLocation and press yes button on warning',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: SignupFlowState(),
            onGeneratePages: onGenerateProfilePages,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AddLocationScreen), findsOneWidget);
      final iconButton = find.byType(IconButton);
      await tester.tap(iconButton.last);
      await tester.pump();
      final textButton = find.byType(TextButton);
      await tester.tap(textButton.first);
      await tester.pump();
    });

    testWidgets('render AddLocation press no button on warning',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: SignupFlowState(),
            onGeneratePages: onGenerateProfilePages,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AddLocationScreen), findsOneWidget);
      final iconButton = find.byType(IconButton);
      await tester.tap(iconButton.last);
      await tester.pump();
      final textButton = find.byType(TextButton);
      await tester.tap(textButton.last);
      await tester.pump();
    });

    testWidgets('render AddLocation with selectLocationWIthCoordinates state',
        (tester) async {
      final cubit = AddLocationCubit();
      await tester.pumpWidget(
        MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: const SignupFlowState(),
            onGeneratePages: (state, pages) =>
                onGenerateProfilePages(state, pages, addLocationCubit: cubit),
          ),
        ),
      );
      cubit.emit(
        const SelectLocationWithCoordinates(
          latitude: 0,
          longitude: 0,
          private: false,
        ),
      );
      await tester.pump();
      expect(find.byType(AddLocationScreen), findsOneWidget);
    });
  });
}

List<Page<void>> onGenerateProfilePages(
  SignupFlowState signupState,
  List<Page<void>> pages, {
  AddLocationCubit? addLocationCubit,
}) {
  final returnPages = <Page<void>>[
    MaterialPage<void>(
      child: AddLocationScreen(addLocationCubit: addLocationCubit),
    )
  ];
  return returnPages;
}

import 'package:datingfoss/authentication/login/bloc/login_bloc.dart';
import 'package:datingfoss/authentication/signup_process/add_bio/add_bio.dart';
import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
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
  group('Add bio', () {
    setUpAll(() {
      final sl = GetIt.instance;
      registerServices(sl);
      sl.registerFactory<LoginBloc>(
        () => LoginBloc(
          authenticationRepository: sl(),
        ),
      );
    });

    List<Page<void>> onGenerateProfilePages(
      SignupFlowState signupState,
      List<Page<void>> pages, {
      bool isPrivate = false,
    }) {
      final returnPages = <Page<void>>[
        MaterialPage<void>(child: AddBio(private: isPrivate))
      ];
      return returnPages;
    }

    Future<void> testAddBio(
      WidgetTester tester, {
      bool isPrivate = false,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlowBuilder<SignupFlowState>(
            state: const SignupFlowState(),
            onGeneratePages: (signupState, pages) => onGenerateProfilePages(
              signupState,
              pages,
              isPrivate: isPrivate,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(AddBio), findsOneWidget);
      final textField = find.byType(TextField).first;
      expect(textField, isNotNull);
      await tester.enterText(textField, 'not a very long bio');
      await tester.pump();
      final submitBioButton = find.byType(SubmitButton);
      await tester.tap(submitBioButton);
      await tester.pump();
    }

    testWidgets(
      'render AddBio private',
      (tester) => testAddBio(
        tester,
        isPrivate: true,
      ),
    );

    testWidgets('render AddBio public', testAddBio);
  });
}

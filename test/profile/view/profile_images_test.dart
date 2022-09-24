import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/profile_images.dart';
import 'package:datingfoss/widgets/empty_picture_slot.dart';
import 'package:datingfoss/widgets/picture_preview.dart';
import 'package:datingfoss/widgets/selection_camera_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:models/models.dart';

// class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('ProfileImages', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    late AppBloc appBloc;
    setUpAll(() {
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      appBloc = MockAppBloc();
      when(() => appBloc.state).thenReturn(
        const AppState.authenticated(
          LocalUser(
            username: 'username',
            publicInfo: PublicInfo(pictures: ['test_resources/pic1.jpg']),
            privateInfo: PrivateInfo(
              pictures: [
                PrivatePic(picId: 'test_resources/pic1.jpg', keyIndex: 0)
              ],
            ),
          ),
        ),
      );
    });

    testWidgets('open dialog when long press on an image', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: profileBloc,
            ),
            BlocProvider.value(
              value: appBloc,
            ),
          ],
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: Column(
                children: const [
                  PublicProfileImages(),
                  PrivateProfileImages(),
                ],
              ),
            ),
          ),
        ),
      );

      final findProfileImages = find.byType(PicturePreview);
      await tester.longPress(findProfileImages.first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('open dialog and press Yes', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: profileBloc,
            ),
            BlocProvider.value(
              value: appBloc,
            ),
          ],
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: Column(
                children: const [
                  PublicProfileImages(),
                  PrivateProfileImages(),
                ],
              ),
            ),
          ),
        ),
      );

      final findProfileImages = find.byType(PicturePreview);
      await tester.longPress(findProfileImages.first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      final findTextButton = find.byType(TextButton);
      await tester.tap(findTextButton.first);
      await tester.pumpAndSettle();
    });

    testWidgets('open dialog and press No', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: profileBloc,
            ),
            BlocProvider.value(
              value: appBloc,
            ),
          ],
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: Column(
                children: const [
                  PublicProfileImages(),
                  PrivateProfileImages(),
                ],
              ),
            ),
          ),
        ),
      );

      final findProfileImages = find.byType(PicturePreview);
      await tester.longPress(findProfileImages.first);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      final findTextButton = find.byType(TextButton);
      await tester.tap(findTextButton.last);
      await tester.pumpAndSettle();
    });

    testWidgets('press add new picture open dialog', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: profileBloc,
            ),
            BlocProvider.value(
              value: appBloc,
            ),
          ],
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: Column(
                children: const [
                  PublicProfileImages(),
                  PrivateProfileImages(),
                ],
              ),
            ),
          ),
        ),
      );

      final findEmptyPictureSlot = find.byType(EmptyPictureSlot);
      await tester.tap(findEmptyPictureSlot.first);
      await tester.pumpAndSettle();

      expect(find.byType(SelectionCameraGallery), findsOneWidget);
    });
  });
}

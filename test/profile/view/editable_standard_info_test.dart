import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/editable_standard_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:models/models.dart';

class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('EditableStandardInfo', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    late AppBloc appBloc;
    const boolInfo = <String, PrivateData<bool>>{};
    const textInfo = <String, PrivateData<String>>{};
    const dateInfo = <String, PrivateData<DateTime>>{};
    const standardInfo = StandardInfo(
      textInfo: textInfo,
      boolInfo: boolInfo,
      dateInfo: dateInfo,
    );
    final child = Container();
    setUpAll(() {
      registerFallbackValue(FakeRoute<StandardInfo?>());
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      appBloc = MockAppBloc();
      when(() => appBloc.state)
          .thenReturn(const AppState.authenticated(LocalUser.empty));
      when(
        () => navigator.push<StandardInfo?>(
          any(that: isRoute<StandardInfo?>()),
        ),
      ).thenAnswer((_) async => standardInfo);
    });

    testWidgets('pushes SexAndOrientationEdit when tapped', (tester) async {
      final editableSexAndOrientation = EditableStandardInfo(child: child);

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
              child: editableSexAndOrientation,
            ),
          ),
        ),
      );

      final findEditableStandardInfo = find.byWidget(editableSexAndOrientation);
      await tester.tap(findEditableStandardInfo);
      await tester.pumpAndSettle();

      verify(
        () =>
            navigator.push<StandardInfo?>(any(that: isRoute<StandardInfo?>())),
      ).called(1);
    });
  });
}

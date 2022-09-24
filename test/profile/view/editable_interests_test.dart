import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/editable_interests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  group('EditableInterests', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    const interests = <String>[];
    final child = Container();
    const private = true;
    setUpAll(() {
      registerFallbackValue(FakeRoute<List<String>?>());
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      when(
        () =>
            navigator.push<List<String>?>(any(that: isRoute<List<String>?>())),
      ).thenAnswer((_) async => interests);
    });

    testWidgets('pushes InterestsEdit when tapped', (tester) async {
      final editableInterests = EditableInterests(
        intialInterests: interests,
        private: private,
        child: child,
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: editableInterests,
            ),
          ),
        ),
      );

      final findEditableInterests = find.byWidget(editableInterests);
      await tester.tap(findEditableInterests);
      await tester.pumpAndSettle();

      verify(
        () =>
            navigator.push<List<String>?>(any(that: isRoute<List<String>?>())),
      ).called(1);
    });
  });
}

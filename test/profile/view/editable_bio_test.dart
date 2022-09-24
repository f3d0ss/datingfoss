import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/editable_bio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  group('EditableBio', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    const bio = 'bio';
    final child = Container();
    const private = true;
    setUpAll(() {
      registerFallbackValue(FakeRoute<String?>());
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      when(() => navigator.push<String?>(any(that: isRoute<String?>())))
          .thenAnswer((_) async => bio);
    });

    testWidgets('pushes BioEdit when tapped', (tester) async {
      final editableBio = EditableBio(
        bio: bio,
        private: private,
        child: child,
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: editableBio,
            ),
          ),
        ),
      );

      final findEditableBio = find.byWidget(editableBio);
      await tester.tap(findEditableBio);
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<String?>(any(that: isRoute<String?>())),
      ).called(1);
    });
  });
}

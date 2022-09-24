import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/editable_sex_and_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:models/models.dart' as model;

class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  group('EditableSexAndOrientation', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    const sex = model.PrivateData<double>(1);
    const searching = model.PrivateData(model.RangeValues(0, 1));
    const sexAndOrientation =
        model.SexAndOrientation(searching: searching, sex: sex);
    final child = Container();
    setUpAll(() {
      registerFallbackValue(FakeRoute<model.SexAndOrientation?>());
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      when(
        () => navigator.push<model.SexAndOrientation?>(
          any(that: isRoute<model.SexAndOrientation?>()),
        ),
      ).thenAnswer((_) async => sexAndOrientation);
    });

    testWidgets('pushes SexAndOrientationEdit when tapped', (tester) async {
      final editableSexAndOrientation = EditableSexAndOrientation(
        sex: sex,
        searching: searching,
        child: child,
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: editableSexAndOrientation,
            ),
          ),
        ),
      );

      final findEditableSexAndOrientation =
          find.byWidget(editableSexAndOrientation);
      await tester.tap(findEditableSexAndOrientation);
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<model.SexAndOrientation?>(
          any(that: isRoute<model.SexAndOrientation?>()),
        ),
      ).called(1);
    });
  });
}

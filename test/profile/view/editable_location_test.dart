import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/profile/bloc/profile_bloc.dart';
import 'package:datingfoss/profile/view/editable_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:models/models.dart';

class FakeRoute<T> extends Fake implements Route<T> {}

class MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  group('EditableLocation', () {
    late MockNavigator navigator;
    late ProfileBloc profileBloc;
    final location = PrivateData(LatLng(12, 12));
    final child = Container();
    setUpAll(() {
      registerFallbackValue(FakeRoute<PrivateData<LatLng>?>());
      navigator = MockNavigator();
      profileBloc = MockProfileBloc();
      when(
        () => navigator.push<PrivateData<LatLng>?>(
          any(that: isRoute<PrivateData<LatLng>?>()),
        ),
      ).thenAnswer((_) async => location);
    });

    testWidgets('pushes LocationEdit when tapped', (tester) async {
      final editableLocation = EditableLocation(
        location: location,
        child: child,
      );

      await tester.pumpWidget(
        BlocProvider.value(
          value: profileBloc,
          child: MaterialApp(
            home: MockNavigatorProvider(
              navigator: navigator,
              child: editableLocation,
            ),
          ),
        ),
      );

      final findEditableLocation = find.byWidget(editableLocation);
      await tester.tap(findEditableLocation);
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<PrivateData<LatLng>?>(
          any(that: isRoute<PrivateData<LatLng>?>()),
        ),
      ).called(1);
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/widgets/privatizable_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSelectSexAndOrientationCubit
    extends MockBloc<SelectSexAndOrientationCubit, SelectSexAndOrientationState>
    implements SelectSexAndOrientationCubit {}

void main() {
  group('PrivatizableDatePicker', () {
    testWidgets('render PrivatizableSexSlider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrivatizableDatePicker(
              labelText: '',
              onDateChanged: (_) {},
              onPrivateChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('can change date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrivatizableDatePicker(
              labelText: '',
              onDateChanged: (_) {},
              onPrivateChanged: (_) {},
            ),
          ),
        ),
      );
      final findIconButton = find.byType(OutlinedButton);
      await tester.tap(findIconButton.first);
      await tester.pump();
      await tester.tap(find.text('OK'));
    });
  });
}

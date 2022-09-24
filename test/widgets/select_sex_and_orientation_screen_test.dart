import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/widgets/privatizable_sex_slider.dart';
import 'package:datingfoss/widgets/select_sex_and_orientation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSelectSexAndOrientationCubit
    extends MockBloc<SelectSexAndOrientationCubit, SelectSexAndOrientationState>
    implements SelectSexAndOrientationCubit {}

void main() {
  group('SelectSexAndOrientationScreen', () {
    late SelectSexAndOrientationCubit selectSexAndOrientationCubit;
    setUp(() {
      selectSexAndOrientationCubit = MockSelectSexAndOrientationCubit();
      when(() => selectSexAndOrientationCubit.state)
          .thenReturn(const SelectSexAndOrientationState());
    });
    testWidgets('render PrivatizableSexSlider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectSexAndOrientationScreen(
              selectSexAndOrientationCubit: selectSexAndOrientationCubit,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(PrivatizableSexSlider), findsOneWidget);
    });

    testWidgets('can put private', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectSexAndOrientationScreen(
              selectSexAndOrientationCubit: selectSexAndOrientationCubit,
            ),
          ),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.first);
      await tester.tap(findIconButton.at(1));
      await tester.pump();
    });

    testWidgets('can change Searching', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectSexAndOrientationScreen(
              selectSexAndOrientationCubit: selectSexAndOrientationCubit,
            ),
          ),
        ),
      );
      final findRangeSlider = find.byType(RangeSlider);
      final rangeSlider =
          findRangeSlider.evaluate().single.widget as RangeSlider;
      rangeSlider.onChanged!(const RangeValues(0, 0));
    });
  });
}

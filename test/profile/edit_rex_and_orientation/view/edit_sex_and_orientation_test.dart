import 'package:datingfoss/profile/edit_sex_and_orientation/view/edit_sex_and_orientation.dart';
import 'package:datingfoss/widgets/select_sex_and_orientation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart' as models;

void main() {
  group('EditSexAndOrientation', () {
    late models.PrivateData<double> initialSex;
    late models.PrivateData<models.RangeValues> initialSearching;
    setUp(() {
      initialSex = const models.PrivateData<double>(1);
      initialSearching = const models.PrivateData<models.RangeValues>(
        models.RangeValues(0, 1),
      );
    });
    testWidgets('render SelectSexAndOrientationScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditSexAndOrientation(
            initialSearching: initialSearching,
            initialSex: initialSex,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SelectSexAndOrientationScreen), findsOneWidget);
    });

    testWidgets('tapp on save button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditSexAndOrientation(
            initialSearching: initialSearching,
            initialSex: initialSex,
          ),
        ),
      );

      final topLeft = tester.getTopLeft(find.byType(Slider).first);
      final bottomRight = tester.getBottomRight(find.byType(Slider).first);

      final target = topLeft + (bottomRight - topLeft) / 4.0;
      await tester.tapAt(target);
      await tester.pump();
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pumpAndSettle();
    });
  });
}

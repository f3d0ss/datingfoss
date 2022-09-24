import 'package:datingfoss/profile/edit_interest/view/edit_interest_screen.dart';
import 'package:datingfoss/widgets/select_interests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditInterestScreen', () {
    late List<String> interests;
    setUp(() {
      interests = ['Interest1', 'Interest2', 'Interest3'];
    });
    testWidgets('render SelectInterests', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditInterestScreen(private: false, initialInterests: interests),
        ),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.byType(AddNewInterestButton), 100);
      await tester.pumpAndSettle();
      expect(find.byType(SelectInterests), findsOneWidget);
    });

    testWidgets('tapp on save button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditInterestScreen(private: false, initialInterests: interests),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pumpAndSettle();
    });
  });
}

import 'package:datingfoss/widgets/insert_new_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InsertNewField', () {
    testWidgets('render TextField', (tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Scaffold(body: InsertNewField())));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('pop if new field is added', (tester) async {
      await tester
          .pumpWidget(MaterialApp(home: Scaffold(body: InsertNewField())));
      final findTextFormField = find.byType(TextField);
      await tester.enterText(findTextFormField.first, 'test');
      await tester.pump();
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pumpAndSettle();
      expect(find.byType(InsertNewField), findsNothing);
    });
  });
}

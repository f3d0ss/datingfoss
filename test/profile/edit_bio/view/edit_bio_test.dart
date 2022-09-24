import 'package:datingfoss/profile/edit_bio/view/edit_bio.dart';
import 'package:datingfoss/widgets/select_bio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditBio', () {
    late String bio;
    late bool private;
    setUp(() {
      private = false;
      bio = 'bio for test';
    });
    testWidgets('render SelectBio', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: EditBio(bio: bio, private: private)),
      );
      await tester.pump();
      expect(find.byType(SelectBio), findsOneWidget);
    });

    testWidgets('tapp on save button after edit a text info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: EditBio(bio: bio, private: private)),
      );
      final findTextFormField = find.byType(TextField);
      await tester.enterText(findTextFormField.first, 'test');
      await tester.pump();
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pump();
    });
  });
}

import 'package:datingfoss/profile/edit_standard_info/view/edit_info_screen.dart';
import 'package:datingfoss/widgets/select_standard_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('EditInfoScreen', () {
    late StandardInfo initialInfo;
    setUp(() {
      initialInfo = StandardInfo(
        textInfo: {
          'text': const PrivateData<String>('data'),
          'text private': const PrivateData<String>('data', private: true)
        },
        dateInfo: {
          'date': PrivateData(DateTime(1)),
          'date private': PrivateData(DateTime(1), private: true)
        },
        boolInfo: {
          'bool': const PrivateData<bool>(true),
          'bool private': const PrivateData<bool>(true, private: true)
        },
      );
    });
    testWidgets('render SelectStandardInfoScreen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: EditInfoScreen(initialInfo: initialInfo)),
      );
      await tester.pump();
      expect(find.byType(SelectStandardInfoScreen), findsOneWidget);
    });

    testWidgets('tapp on save button after edit a text info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditInfoScreen(initialInfo: initialInfo),
        ),
      );
      final findTextFormField = find.byType(TextFormField);
      await tester.enterText(findTextFormField.first, 'test');
      await tester.pump();
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.pump();
    });
  });
}

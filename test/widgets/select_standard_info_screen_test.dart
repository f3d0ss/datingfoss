import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:datingfoss/widgets/select_standard_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

class MockSelectStandardInfoCubit
    extends MockBloc<SelectStandardInfoCubit, SelectStandardInfoState>
    implements SelectStandardInfoCubit {}

void main() {
  group('PrivatizableInputWrappedInDismissible', () {
    testWidgets('render Dismissible', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrivatizableInputWrappedInDismissible(
              id: '',
              child: Container(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('can dismiss', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<SelectStandardInfoCubit>(
              create: (context) => MockSelectStandardInfoCubit(),
              child: PrivatizableInputWrappedInDismissible(
                id: '',
                child: Container(),
              ),
            ),
          ),
        ),
      );
      final findDismissible = find.byType(Dismissible);
      final dismissible =
          findDismissible.evaluate().single.widget as Dismissible;
      unawaited(dismissible.confirmDismiss!(DismissDirection.endToStart));
      dismissible.onDismissed!(DismissDirection.endToStart);
      await tester.pumpAndSettle();
    });
  });

  group('ListTextInfo', () {
    testWidgets('render ListTextInfo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ListTextInfo(textInfo: {}))),
      );
      await tester.pump();
      expect(find.byType(ListTextInfo), findsOneWidget);
    });

    testWidgets('can add', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<SelectStandardInfoCubit>(
              create: (context) => MockSelectStandardInfoCubit(),
              child: const ListTextInfo(
                textInfo: {'text': TextInfo.pure(PrivateData('text'))},
              ),
            ),
          ),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.tap(findIconButton.first);
      await tester.pump();
    });
  });
  group('ListDateInfo', () {
    testWidgets('render ListDateInfo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ListDateInfo(dateInfo: {}))),
      );
      await tester.pump();
      expect(find.byType(ListDateInfo), findsOneWidget);
    });

    testWidgets('can add', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<SelectStandardInfoCubit>(
              create: (context) => MockSelectStandardInfoCubit(),
              child: const ListDateInfo(
                dateInfo: {'text': DateInfo.pure(PrivateData(null))},
              ),
            ),
          ),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.tap(findIconButton.first);
      await tester.pump();
    });
  });

  group('ListBoolInfo', () {
    testWidgets('render ListBoolInfo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ListBoolInfo(boolInfo: {}))),
      );
      await tester.pump();
      expect(find.byType(ListBoolInfo), findsOneWidget);
    });

    testWidgets('can add', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<SelectStandardInfoCubit>(
              create: (context) => MockSelectStandardInfoCubit(),
              child: const ListBoolInfo(
                boolInfo: {'text': BoolInfo(PrivateData(true))},
              ),
            ),
          ),
        ),
      );
      final findIconButton = find.byType(IconButton);
      await tester.tap(findIconButton.last);
      await tester.tap(findIconButton.first);
      await tester.pump();
    });
  });
}

import 'package:datingfoss/chat/view/list_chat_item.dart';
import 'package:datingfoss/main.dart' as app;
import 'package:datingfoss/match/view/match_widget.dart';
import 'package:datingfoss/widgets/bio_widget.dart';
import 'package:datingfoss/widgets/location_widget.dart';
import 'package:datingfoss/widgets/privatizable_searching_slider.dart';
import 'package:datingfoss/widgets/privatizable_sex_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tcard/tcard.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app.main();

  testWidgets('Login, put like, send message and logout',
      (WidgetTester tester) async {
    await binding.convertFlutterSurfaceToImage();

    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 170));
    await binding.takeScreenshot('login');
    await tester.pumpAndSettle();

    await login(tester, binding);

    // Wait for partner pictures to load
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    await putLike(tester, binding);

    await navigateToChat(tester, binding);

    await openSingleChat(tester, binding);

    await sendAMessage(tester, binding);

    await openPartnerDetail(tester, binding);

    await closePartnerDetail(tester, binding);

    await closeSingleChat(tester, binding);

    await navigateToProfile(tester, binding);

    await logout(tester, binding);

    await binding.takeScreenshot('end');
  });
}

Future<void> login(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Enter signup credential
  final findUsernameTextField = find.byType(TextField).first;
  await tester.enterText(findUsernameTextField, 'mark88');
  await tester.enterText(find.byType(TextField).last, 'mark8888');
  await tester.testTextInput.receiveAction(TextInputAction.done);

  // SignUp
  await tester.pumpAndSettle();
  await binding.takeScreenshot('login-filled');
  await tester.tap(find.text('LOGIN'));
  await tester.pumpAndSettle();
}

Future<void> putLike(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Select sex and orientation
  await binding.takeScreenshot('discover-screen');
  await tester.drag(find.byType(TCard), const Offset(500, 0));
  // Wait untill animation is visible
  while (tester.any(find.byType(NewMatchAnimation))) {
    await tester.pump(const Duration(milliseconds: 17));
  }
  for (var count = 0; count < 6; count += 1) {
    await binding.takeScreenshot('discover-screen-match-animation');
    await tester.pump(const Duration(milliseconds: 680));
  }
  await tester.pump();
  await binding.takeScreenshot('discover-screen-dragged-end');
}

Future<void> navigateToChat(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.tap(find.byIcon(Icons.chat));
  await tester.pump();
  await binding.takeScreenshot('chat-screen');
}

Future<void> openSingleChat(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.tap(find.byType(ListChatItem).first);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('single-chat-screen');
}

Future<void> sendAMessage(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.enterText(find.byType(TextFormField), 'Hi m8!');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('send-a-message');
  await tester.tap(find.text('Send'));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await binding.takeScreenshot('send-a-message-sent');
}

Future<void> openPartnerDetail(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.tap(find.byIcon(Icons.remove_red_eye_outlined));
  await tester.pumpAndSettle();
  await binding.takeScreenshot('partner-detail-screen');
  await tester.dragUntilVisible(
    getLastProfileWidget(tester),
    find.byType(ListView), // widget you want to scroll
    const Offset(-250, 0), // delta to move
  );
  await tester.pumpAndSettle();
  await binding.takeScreenshot('partner-detail-screen-2');
}

Future<void> closePartnerDetail(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  if (tester.any(find.byIcon(Icons.arrow_back))) {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await binding.takeScreenshot('partner-detail-closed');
  }
}

Future<void> closeSingleChat(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  if (tester.any(find.byIcon(Icons.arrow_back))) {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await binding.takeScreenshot('profile-screen');
  }
}

Future<void> navigateToProfile(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.tap(find.byIcon(Icons.person));
  // Be sure to show images
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await tester.pump(const Duration(milliseconds: 170));
  await binding.takeScreenshot('profile-screen');
}

Future<void> logout(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.dragUntilVisible(
    find.text('Logout'),
    find.byType(ListView), // widget you want to scroll
    const Offset(-250, 0), // delta to move
  );
  await tester.pumpAndSettle();
  await binding.takeScreenshot('profile-screen-2');
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  await binding.takeScreenshot('logged-out');
}

Finder getLastProfileWidget(WidgetTester tester) {
  final findLastWidgets = [
    find.byType(LocationWidget),
    find.byType(PrivatizableSexSlider),
    find.byType(PrivatizableSearchingSlider),
  ];
  for (final findWidget in findLastWidgets) {
    if (tester.any(findWidget)) return findWidget;
  }
  return find.byType(BioWidget);
}

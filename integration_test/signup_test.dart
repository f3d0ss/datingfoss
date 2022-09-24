import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/main.dart' as app;
import 'package:datingfoss/utils/get_file_from_asset.dart';
import 'package:datingfoss/widgets/empty_picture_slot.dart';
import 'package:datingfoss/widgets/select_interests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

const MethodChannel channel =
    MethodChannel('plugins.flutter.io/image_picker_android');
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    final sourceType = (methodCall.arguments as Map)['source'] as int;
    final fileAsset = sourceType == 0 ? 'mock/pic1.jpg' : 'mock/pic2.jpg';
    final file = await GetFileFromAsset().getImageFileFromAssets(fileAsset);
    return file.path;
  });

  app.main();

  testWidgets('Signup', (WidgetTester tester) async {
    await binding.convertFlutterSurfaceToImage();

    await tester.pumpAndSettle(const Duration(milliseconds: 170));
    await tester.pumpAndSettle(const Duration(milliseconds: 170));
    await binding.takeScreenshot('login');

    // Navigate to Signup Page
    await navigateToSignup(tester, binding);

    await signUp(tester, binding);

    await addLocation(tester, binding);

    await addSexAndOrientation(tester, binding);

    await addStandardInfo(tester, binding);

    await addPublicInterest(tester, binding);

    await addPrivateInterest(tester, binding);

    await addPublicBio(tester, binding);

    await addPrivateBio(tester, binding);

    await addPublicPictures(tester, binding);

    await addPrivatePictures(tester, binding);

    // Select Public Interests
    await tester.pumpAndSettle();
    // Wait for fetch partners
    await Future<void>.delayed(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('end');
  });
}

Future<void> navigateToSignup(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.tap(find.text('SIGNUP'));
  await tester.pumpAndSettle();
  await binding.takeScreenshot('signup');
}

Future<void> signUp(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Enter signup credential
  final findUsernameTextField = find.byType(TextField).first;
  await tester.enterText(findUsernameTextField, 'mr_bob');
  await tester.enterText(find.byType(TextField).last, 'Password000');
  await tester.testTextInput.receiveAction(TextInputAction.done);

  // SignUp
  await tester.pumpAndSettle();
  await binding.takeScreenshot('signup-filled');
  await tester.tap(find.text('SIGNUP'));
  await tester.pumpAndSettle();
}

Future<void> addLocation(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Select location
  await tester.tap(find.byType(FlutterMap));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await Future<void>.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await Future<void>.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await Future<void>.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await binding.takeScreenshot('map');
  await tester.tap(find.byIcon(Icons.done));
  await tester.pumpAndSettle();
}

Future<void> addSexAndOrientation(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Select sex and orientation
  await binding.takeScreenshot('sex-and-orientation');
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addStandardInfo(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  // Select standard info
  // Insert text field
  await binding.takeScreenshot('standard-info');
  await tester.enterText(find.byType(TextField).last, 'Bravo');
  await tester.enterText(find.byType(TextField).first, 'Bobby');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('standard-info-text');
  // // Insert date field
  await tester.tap(find.byType(OutlinedButton));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  await tester.pumpAndSettle();
  await binding.takeScreenshot('standard-info-date');
  await tester.dragUntilVisible(
    find.byType(Checkbox).first,
    find.byType(ListView), // widget you want to scroll
    const Offset(-250, 0), // delta to move
  );
  await tester.pumpAndSettle();
  // Insert bool field
  await tester.tap(find.byType(Checkbox).first);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('standard-info-bool');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPublicInterest(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('public-interest');
  await tester.tap(find.byType(InterestButton).first);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('public-interest-selected');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPrivateInterest(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('private-interest');
  await tester.tap(find.byType(InterestButton).last);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('private-interest-selected');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPublicBio(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('public-bio');
  await tester.enterText(
    find.byType(TextField),
    '''Infuriatingly humble twitter maven. Coffee fanatic. Pop culture trailblazer. Social media enthusiast. Reader. Devoted travel guru.''',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('public-bio-selected');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPrivateBio(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('private-bio');
  await tester.enterText(
    find.byType(TextField),
    '''Unapologetic alcohol guru. Twitter practitioner. Food specialist. Avid music nerd. Friendly beer fanatic.''',
  );
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await binding.takeScreenshot('private-bio-selected');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPublicPictures(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('public-pictures');
  await tester.tap(find.byType(EmptyPictureSlot).first);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('public-pictures-dialog');
  await tester.tap(find.text('Camera'));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await binding.takeScreenshot('public-pictures-selected');
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

Future<void> addPrivatePictures(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await binding.takeScreenshot('private-pictures');
  await tester.tap(find.byType(EmptyPictureSlot).first);
  await tester.pumpAndSettle();
  await binding.takeScreenshot('private-pictures-dialog');
  await tester.tap(find.text('Gallery'));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await tester.pumpAndSettle(const Duration(milliseconds: 170));
  await binding.takeScreenshot('private-pictures-selected');
  await tester.pumpAndSettle();
  // Submit
  await tester.tap(find.byType(SubmitButton));
  await tester.pumpAndSettle();
}

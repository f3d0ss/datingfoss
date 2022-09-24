import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';
import 'package:mock_generator/mock_generator.dart';

Future<void> main() async {
  const screenshotFolder = 'screenshot';
  var index = 0;

  final mockGenerator = MockGenerator(basePath: 'packages/mock_generator/');
  await mockGenerator.cleanServer();
  await mockGenerator.seedServer();

  final directory = Directory(screenshotFolder);
  if (directory.existsSync()) directory.deleteSync(recursive: true);

  await integrationDriver(
    onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
      final screenshot = File(
        '$screenshotFolder/${index < 10 ? 0 : ''}${index++}-$screenshotName.png',
      );
      await screenshot.create(recursive: true);
      screenshot.writeAsBytesSync(screenshotBytes);
      return true;
    },
  );
}

import 'package:mock_generator/src/mock_generator.dart';

void main(List<String> args) async {
  final mockGenerator = MockGenerator();
  await mockGenerator.cleanServer();
  await mockGenerator.seedServer();
}

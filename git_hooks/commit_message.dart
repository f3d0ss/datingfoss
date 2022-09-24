// ignore_for_file: avoid_print

import 'dart:io';

dynamic main() {
  final rootDir = Directory.current;
  final commitFile = File('${rootDir.path}/.git/COMMIT_EDITMSG');
  final commitMessage = commitFile.readAsStringSync();

  final regExp = RegExp(
    r'^(?<type>build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test|¯\\_\(ツ\)_\/¯)(?<scope>\(\w+\)?((?=:\s)|(?=!:\s)))?(?<breaking>!)?(?<subject>:\s.*)?|^(?<merge>Merge \w+)',
  );

  final valid = regExp.hasMatch(commitMessage);
  if (!valid) {
    print(
      '''👎 Bad commit message! User Conventional commit standard:
    https://www.conventionalcommits.org/en/v1.0.0/''',
    );
    exitCode = 1;
  } else {
    print('''👍 Nice commit message dude!''');
  }
}

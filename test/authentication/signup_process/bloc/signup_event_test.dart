// ignore_for_file: prefer_const_constructors
import 'package:datingfoss/authentication/signup_process/bloc/signup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockUser extends Mock implements LocalUser {}

void main() {
  group('SignupEvent', () {
    final localSignupUser = LocalSignupUser();
    test('supports value comparisons', () {
      expect(
        SignupRequested(user: localSignupUser),
        SignupRequested(user: localSignupUser),
      );
    });
  });
}

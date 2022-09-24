import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_location/cubit/add_location_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/authentication/signup_process/bloc/signup_bloc.dart';
import 'package:datingfoss/authentication/signup_process/signup.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/cubit/signup_credential_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockSignupBloc extends MockBloc<SignupEvent, SignupState>
    implements SignupBloc {}

class MockSignupCredentialCubit extends MockCubit<SignupCredentialState>
    implements SignupCredentialCubit {}

void main() {
  group('Add Signup', () {
    late SignupBloc signupBloc;
    late SignupCredentialCubit signupCredentialCubit;
    setUpAll(() {
      final sl = GetIt.instance;
      signupBloc = MockSignupBloc();
      signupCredentialCubit = MockSignupCredentialCubit();
      sl
        ..registerFactory(() => signupBloc)
        ..registerFactory(() => signupCredentialCubit);
      when(() => signupBloc.state).thenReturn(const SignupState());
      when(() => signupCredentialCubit.state)
          .thenReturn(const SignupCredentialState());
      registerCubits(sl);
    });

    test('can get route', () {
      expect(SignUpFlow.route(), isA<MaterialPageRoute<SignupFlowState>>());
    });

    testWidgets(
      'render initial',
      (tester) => renderByStatus(tester, SignupStatus.initial),
    );

    testWidgets(
      'render selecting location',
      (tester) => renderByStatus(tester, SignupStatus.selectingLocation),
    );

    testWidgets(
      'render private bio',
      (tester) => renderByStatus(tester, SignupStatus.selectingPrivateBio),
    );

    testWidgets(
      'render public bio',
      (tester) => renderByStatus(tester, SignupStatus.selectingPublicBio),
    );

    testWidgets(
      'render private interests',
      (tester) =>
          renderByStatus(tester, SignupStatus.selectingPrivateInterests),
    );

    testWidgets(
      'render public interests',
      (tester) => renderByStatus(tester, SignupStatus.selectingPublicInterests),
    );

    testWidgets(
      'render public pictures',
      (tester) => renderByStatus(tester, SignupStatus.selectingPublicPictures),
    );

    testWidgets(
      'render private pictures',
      (tester) => renderByStatus(tester, SignupStatus.selectingPrivatePictures),
    );

    testWidgets(
      'render selecting sex and orientation',
      (tester) =>
          renderByStatus(tester, SignupStatus.selectingSexAndOrientation),
    );

    testWidgets(
      'render selecting standard info',
      (tester) => renderByStatus(tester, SignupStatus.selectingStandardInfo),
    );

    testWidgets(
        'throw if onGeneratedProfilePages is called after signup completion',
        (tester) async {
      expect(
        () => onGenerateProfilePages(
          const SignupFlowState(signupStatus: SignupStatus.completed),
          [],
        ),
        throwsA(isA<Exception>()),
      );
    });

    group('Bloc go to signedUp', () {
      setUp(() {
        whenListen(
          signupBloc,
          Stream.fromIterable(
            [
              const SignupState(),
              const SignupState(signupBlocState: SignupBlocState.signedUp),
            ],
          ),
        );
      });
      testWidgets('render LoadingSignup', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: SignUpFlow(),
          ),
        );
      });
    });
  });
}

void registerCubits(GetIt sl) {
  sl
    ..registerFactory(AddLocationCubit.new)
    ..registerFactory(AddSexAndOrientationCubit.new)
    ..registerFactory(AddPublicPicturesCubit.new)
    ..registerFactory(AddPrivatePicturesCubit.new);
}

Future<void> renderByStatus(
  WidgetTester tester,
  SignupStatus status,
) async {
  final state = SignupFlowState(signupStatus: status);
  await tester.pumpWidget(
    MaterialApp(
      home: SignUpFlow(state: state),
    ),
  );
  await tester.pump();
  expect(find.byType(SignUpFlow), findsOneWidget);
}

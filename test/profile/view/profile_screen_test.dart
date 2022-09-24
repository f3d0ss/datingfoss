import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart' as model;
import 'package:repositories/repositories.dart';

class MockUser extends Mock implements model.LocalUser {}

class MockAuthenticationRepository extends Mock implements UserRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  late AppBloc appBloc;
  setUpAll(() {
    appBloc = MockAppBloc();
    GetIt.instance.registerFactory<AppBloc>(() => appBloc);
  });
  group('ProfileScreen', () {
    late UserRepository authenticationRepository;
    late model.LocalUser user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = const model.LocalUser(
        username: 'username',
        publicInfo:
            model.PublicInfo(sex: 0.5, searching: model.RangeValues(0, 0.5)),
        privateInfo: model.PrivateInfo.empty,
      );

      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
    });

    testWidgets('change main page when state change mainPage', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(2000, 1500);
      // resets the screen to its original size after the test end
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: appBloc,
            child: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/cubit/add_sex_and_orientation_cubit.dart';
import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('select sex and orientation', () {
    var signUpFlow = FlowController<SignupFlowState>(const SignupFlowState());
    setUp(() {});
    test('Initial state should be SelectSexAndOrientationState', () {
      final cubit = AddSexAndOrientationCubit();
      expect(cubit.state, const SelectSexAndOrientationState());
    });

    blocTest<AddSexAndOrientationCubit, SelectSexAndOrientationState>(
      '''searching property should change correctly if searching changed
       is called''',
      build: AddSexAndOrientationCubit.new,
      act: (cubit) => cubit.searchingChanged(
        private: false,
        searching: const RangeValues(0.2, 0.7),
      ),
      verify: (cubit) {
        final searching = cubit.state.searching;
        expect(searching.data.end, 0.7);
        expect(searching.data.start, 0.2);
        expect(searching.private, false);
      },
    );

    blocTest<AddSexAndOrientationCubit, SelectSexAndOrientationState>(
      'sex property should change correctly if sex changed is called',
      build: AddSexAndOrientationCubit.new,
      act: (cubit) => cubit.sexChanged(sex: 0.3, private: true),
      verify: (cubit) {
        final sex = cubit.state.sex;
        expect(sex.data, 0.3);
        expect(sex.private, true);
      },
    );

    blocTest<AddSexAndOrientationCubit, SelectSexAndOrientationState>(
      'Signup flow status should be selectingStandardInfo on commit',
      build: AddSexAndOrientationCubit.new,
      act: (cubit) => cubit.submitted(
        signUpFlow = FlowController<SignupFlowState>(const SignupFlowState()),
      ),
      verify: (cubit) {
        expect(
          signUpFlow.state.signupStatus,
          SignupStatus.selectingStandardInfo,
        );
      },
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_standard_info/cubit/add_standard_info_cubit.dart';
import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('add standard info cubit test', () {
    final textInfo = {'A': const TextInfo.pure(PrivateData('A'))};

    final dateInfo = {'B': DateInfo.pure(PrivateData(DateTime.now()))};

    final boolInfo = {'C': const BoolInfo(PrivateData(true))};

    test('Initial state should be SelectStandardInfoState', () {
      final cubit = AddStandardInfoCubit(textInfo, dateInfo, boolInfo);
      expect(
        cubit.state,
        SelectStandardInfoState(
          textInfo: textInfo,
          dateInfo: dateInfo,
          boolInfo: boolInfo,
        ),
      );
    });

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'textInfoChanged should update text info with new data',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.textInfoChanged('A', data: 'NewData'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.first.value.data.data, 'NewData');
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'dateInfoChanged should update date info with new data',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.dateInfoChanged('B', data: DateTime(1)),
      verify: (cubit) {
        expect(cubit.state.dateInfo.entries.first.value.data.data, DateTime(1));
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'boolInfoChanged should update bool info with new data',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.boolInfoChanged('C', data: true),
      verify: (cubit) {
        expect(cubit.state.boolInfo.entries.first.value.data.data, true);
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'textInfoAdded should add a new text info',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.textInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.length, 2);
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'dateInfoAdded should add a new date info',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.dateInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.dateInfo.entries.length, 2);
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'boolInfoAdded should add a new bool info',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.boolInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.boolInfo.entries.length, 2);
      },
    );

    blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
      'info removed should remove a info giver his key',
      build: () => AddStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.infoRemoved('A'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.length, 0);
      },
    );

    group('SignUp flow tests', () {
      var signUpFlow = FlowController<SignupFlowState>(const SignupFlowState());

      blocTest<AddStandardInfoCubit, SelectStandardInfoState>(
        'submitted should change signup flow to selectingPublicInterests',
        seed: () => SelectStandardInfoState(
          status: InfoStatus.valid,
          boolInfo: {...boolInfo},
          dateInfo: {
            ...dateInfo,
            'Bob': const DateInfo.dirty(PrivateData(null))
          },
          textInfo: {...textInfo},
        ),
        build: () => AddStandardInfoCubit(
          {...textInfo},
          {...dateInfo, 'Bob': const DateInfo.dirty(PrivateData(null))},
          {...boolInfo},
        ),
        act: (cubit) => cubit.submitted(
          signUpFlow = FlowController<SignupFlowState>(
            const SignupFlowState(),
          ),
        ),
        verify: (cubit) {
          expect(
            signUpFlow.state.signupStatus,
            SignupStatus.selectingPublicInterests,
          );
        },
      );
    });
  });
}

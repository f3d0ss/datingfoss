import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:datingfoss/profile/edit_standard_info/cubit/edit_standard_info_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('EditStandardInfoCubit', () {
    final textInfo = {'A': const TextInfo.pure(PrivateData('A'))};

    final dateInfo = {'B': DateInfo.pure(PrivateData(DateTime.now()))};

    final boolInfo = {'C': const BoolInfo(PrivateData(true))};

    test('Initial state should be SelectStandardInfoState', () {
      final cubit = EditStandardInfoCubit(textInfo, dateInfo, boolInfo);
      expect(
        cubit.state,
        SelectStandardInfoState(
          textInfo: textInfo,
          dateInfo: dateInfo,
          boolInfo: boolInfo,
        ),
      );
    });

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'textInfoChanged should update text info with new data',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.textInfoChanged('A', data: 'NewData'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.first.value.data.data, 'NewData');
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'dateInfoChanged should update date info with new data',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.dateInfoChanged('B', data: DateTime(1)),
      verify: (cubit) {
        expect(cubit.state.dateInfo.entries.first.value.data.data, DateTime(1));
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'boolInfoChanged should update bool info with new data',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.boolInfoChanged('C', data: true),
      verify: (cubit) {
        expect(cubit.state.boolInfo.entries.first.value.data.data, true);
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'textInfoAdded should add a new text info',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.textInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.length, 2);
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'dateInfoAdded should add a new date info',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.dateInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.dateInfo.entries.length, 2);
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'boolInfoAdded should add a new bool info',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.boolInfoAdded('New'),
      verify: (cubit) {
        expect(cubit.state.boolInfo.entries.length, 2);
      },
    );

    blocTest<EditStandardInfoCubit, SelectStandardInfoState>(
      'info removed should remove a info giver his key',
      build: () => EditStandardInfoCubit(textInfo, dateInfo, boolInfo),
      act: (cubit) => cubit.infoRemoved('A'),
      verify: (cubit) {
        expect(cubit.state.textInfo.entries.length, 0);
      },
    );
  });
}

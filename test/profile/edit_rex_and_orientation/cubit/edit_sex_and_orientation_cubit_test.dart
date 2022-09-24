import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/profile/edit_sex_and_orientation/cubit/edit_sex_and_orientation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:models/models.dart';

void main() {
  group('EditSexAndOrientationCubit', () {
    const initialSex = PrivateData<double>(0.1);
    const initialSearching = PrivateData<RangeValues>(RangeValues(0.1, 0.3));
    setUp(() {});
    test('Initial state should be SelectSexAndOrientationState', () {
      final cubit = EditSexAndOrientationCubit(
        initialSex: initialSex,
        initialSearching: initialSearching,
      );
      expect(
        cubit.state,
        const SelectSexAndOrientationState(
          sex: initialSex,
          searching: initialSearching,
        ),
      );
    });

    blocTest<EditSexAndOrientationCubit, SelectSexAndOrientationState>(
      '''searching property should change correctly if searching changed
       is called''',
      build: () => EditSexAndOrientationCubit(
        initialSex: initialSex,
        initialSearching: initialSearching,
      ),
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

    blocTest<EditSexAndOrientationCubit, SelectSexAndOrientationState>(
      'sex property should change correctly if sex changed is called',
      build: () => EditSexAndOrientationCubit(
        initialSex: initialSex,
        initialSearching: initialSearching,
      ),
      act: (cubit) => cubit.sexChanged(sex: 0.3, private: true),
      verify: (cubit) {
        final sex = cubit.state.sex;
        expect(sex.data, 0.3);
        expect(sex.private, true);
      },
    );
  });
}

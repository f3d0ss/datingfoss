import 'package:bloc_test/bloc_test.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_private_pictures_cubit.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/cubit/add_public_pictures_cubit.dart';
import 'package:file/file.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

class MockFile extends Mock implements File {}

void main() {
  final file = MockFile();
  group('add pictures tests', () {
    test('Initial state should be AddPicturesState', () {
      final cubit = AddPublicPicturesCubit();
      expect(cubit.state, const AddPicturesState());
    });

    blocTest<AddPicturesCubit, AddPicturesState>(
      'addedPicture should set pictures state in valid state',
      build: AddPublicPicturesCubit.new,
      act: (cubit) => cubit.addedPicture(null),
      verify: (cubit) {
        expect(cubit.state.status, PicturesStatus.valid);
      },
    );

    blocTest<AddPicturesCubit, AddPicturesState>(
      'removed picture should remove a picture from the list',
      seed: () => AddPicturesState(pictures: [file]),
      build: AddPublicPicturesCubit.new,
      act: (cubit) => cubit.removedPicture(file),
      verify: (cubit) {
        expect(cubit.state.pictures.length, 0);
      },
    );

    blocTest<AddPicturesCubit, AddPicturesState>(
      'selectedAddPicture should set state in addPicture',
      seed: () => AddPicturesState(pictures: [file]),
      build: AddPublicPicturesCubit.new,
      act: (cubit) => cubit.selectedAddPicture(),
      verify: (cubit) {
        expect(cubit.state.status, PicturesStatus.addPicture);
      },
    );

    group('sgnuUpFlow test', () {
      blocTest<AddPicturesCubit, AddPicturesState>(
        'selectedAddPicture should set state in valid with some pictures',
        seed: () => AddPicturesState(pictures: [file]),
        build: AddPublicPicturesCubit.new,
        act: (cubit) => cubit.submitted(
          FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(cubit.state.status, PicturesStatus.valid);
        },
      );

      blocTest<AddPicturesCubit, AddPicturesState>(
        'selectedAddPicture should set state in warning with 0 pictures',
        seed: () => const AddPicturesState(),
        build: AddPublicPicturesCubit.new,
        act: (cubit) => cubit.submitted(
          FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(cubit.state.status, PicturesStatus.warning);
        },
      );

      blocTest<AddPicturesCubit, AddPicturesState>(
        'forceSubmit should set state in submitted if state is in warning',
        seed: () => const AddPicturesState(status: PicturesStatus.warning),
        build: AddPrivatePicturesCubit.new,
        act: (cubit) => cubit.forceSubmit(
          FlowController<SignupFlowState>(const SignupFlowState()),
        ),
        verify: (cubit) {
          expect(cubit.state.status, PicturesStatus.submitted);
        },
      );

      blocTest<AddPicturesCubit, AddPicturesState>(
        'forceSubmit should set state in valid if state is in warning',
        seed: () => const AddPicturesState(status: PicturesStatus.warning),
        build: AddPublicPicturesCubit.new,
        act: (cubit) => cubit.dismissWarning(),
        verify: (cubit) {
          expect(cubit.state.status, PicturesStatus.valid);
        },
      );
    });
  });
}

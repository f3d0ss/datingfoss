import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:models/models.dart';

part 'add_pictures_state.dart';

abstract class AddPicturesCubit extends Cubit<AddPicturesState> {
  AddPicturesCubit() : super(const AddPicturesState());

  void addedPicture(File? newPicture) {
    if (newPicture != null) {
      emit(
        state.copyWith(
          status: PicturesStatus.valid,
          pictures: [...state.pictures, newPicture],
        ),
      );
    }
    emit(
      state.copyWith(status: PicturesStatus.valid),
    );
  }

  void removedPicture(File picture) {
    final newPictures = [...state.pictures]..remove(picture);
    emit(
      state.copyWith(
        pictures: newPictures,
      ),
    );
  }

  void selectedAddPicture() {
    emit(state.copyWith(status: PicturesStatus.addPicture));
  }

  void submitted(FlowController<SignupFlowState> flow) {
    if (state.pictures.isEmpty) {
      emit(state.copyWith(status: PicturesStatus.warning));
    } else {
      emit(state.copyWith(status: PicturesStatus.valid));
      updateFlow(flow);
    }
  }

  void forceSubmit(FlowController<SignupFlowState> flow) {
    if (state.status == PicturesStatus.warning) {
      emit(state.copyWith(status: PicturesStatus.submitted));
      updateFlow(flow);
    }
  }

  void dismissWarning() {
    if (state.status == PicturesStatus.warning) {
      emit(state.copyWith(status: PicturesStatus.valid));
    }
  }

  void updateFlow(FlowController<SignupFlowState> flow);
}

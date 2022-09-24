import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

part 'select_standard_info_state.dart';

class SelectStandardInfoCubit extends Cubit<SelectStandardInfoState> {
  SelectStandardInfoCubit(
    Map<String, TextInfo> textInfo,
    Map<String, DateInfo> dateInfo,
    Map<String, BoolInfo> boolInfo,
  ) : super(
          SelectStandardInfoState(
            textInfo: textInfo,
            dateInfo: dateInfo,
            boolInfo: boolInfo,
          ),
        );

  void textInfoChanged(String key, {String? data, bool? private}) {
    final newTextInfo = {...state.textInfo}..update(
        key,
        (value) => TextInfo.dirty(
          value.data.copyWith(data: data, private: private),
        ),
      );
    emit(
      state.copyWith(
        textInfo: newTextInfo,
        status: Info.validate([
          ...newTextInfo.values,
          ...state.dateInfo.values,
          ...state.boolInfo.values,
        ]),
      ),
    );
  }

  void dateInfoChanged(String key, {DateTime? data, bool? private}) {
    final newDateInfo = {...state.dateInfo}..update(
        key,
        (value) => DateInfo.dirty(
          value.data.copyWith(data: data, private: private),
        ),
      );
    emit(
      state.copyWith(
        dateInfo: newDateInfo,
        status: Info.validate([
          ...newDateInfo.values,
          ...state.textInfo.values,
          ...state.boolInfo.values,
        ]),
      ),
    );
  }

  void boolInfoChanged(String key, {bool? data, bool? private}) {
    final newBoolInfo = {...state.boolInfo}..update(
        key,
        (value) => BoolInfo(
          value.data.copyWith(data: data, private: private),
        ),
      );
    emit(
      state.copyWith(
        boolInfo: newBoolInfo,
        status: Info.validate([
          ...newBoolInfo.values,
          ...state.textInfo.values,
          ...state.dateInfo.values,
        ]),
      ),
    );
  }

  void textInfoAdded(String inputName) {
    final newTextInfo = {...state.textInfo}..putIfAbsent(
        inputName,
        () => const TextInfo.pure(PrivateData<String>('')),
      );
    emit(
      state.copyWith(
        textInfo: newTextInfo,
        status: Info.validate([
          ...newTextInfo.values,
          ...state.dateInfo.values,
          ...state.boolInfo.values,
        ]),
      ),
    );
  }

  void dateInfoAdded(String inputName) {
    final newDateInfo = {...state.dateInfo}..putIfAbsent(
        inputName,
        () => const DateInfo.dirty(PrivateData<DateTime?>(null)),
      );
    emit(
      state.copyWith(
        dateInfo: newDateInfo,
        status: Info.validate([
          ...newDateInfo.values,
          ...state.textInfo.values,
          ...state.boolInfo.values,
        ]),
      ),
    );
  }

  void boolInfoAdded(String inputName) {
    final newBoolInfo = {...state.boolInfo}..putIfAbsent(
        inputName,
        () => const BoolInfo(PrivateData<bool>(false)),
      );
    emit(
      state.copyWith(
        boolInfo: newBoolInfo,
        status: Info.validate([
          ...newBoolInfo.values,
          ...state.textInfo.values,
          ...state.dateInfo.values,
        ]),
      ),
    );
  }

  void infoRemoved(String key) {
    final newTextInfo = {...state.textInfo}..remove(key);
    final newDateInfo = {...state.dateInfo}..remove(key);
    final newBoolInfo = {...state.boolInfo}..remove(key);
    emit(
      state.copyWith(
        textInfo: newTextInfo,
        dateInfo: newDateInfo,
        boolInfo: newBoolInfo,
        status: Info.validate(newTextInfo.values.toList()),
      ),
    );
  }
}

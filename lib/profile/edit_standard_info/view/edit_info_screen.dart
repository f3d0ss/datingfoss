import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:datingfoss/profile/edit_standard_info/cubit/edit_standard_info_cubit.dart';
import 'package:datingfoss/widgets/select_standard_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class EditInfoScreen extends StatelessWidget {
  const EditInfoScreen({super.key, required this.initialInfo});

  final StandardInfo initialInfo;

  static Route<StandardInfo> route(StandardInfo standardInfo) {
    return MaterialPageRoute(
      builder: (_) => EditInfoScreen(initialInfo: standardInfo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editStandardInfoCubit = EditStandardInfoCubit(
      initialInfo.textInfo
          .map((key, value) => MapEntry(key, TextInfo.dirty(value))),
      initialInfo.dateInfo
          .map((key, value) => MapEntry(key, DateInfo.dirty(value))),
      initialInfo.boolInfo.map((key, value) => MapEntry(key, BoolInfo(value))),
    );
    return SelectStandardInfoScreen(
      selectStandardInfoCubit: editStandardInfoCubit,
      appBarButton: BlocBuilder<EditStandardInfoCubit, SelectStandardInfoState>(
        bloc: editStandardInfoCubit,
        builder: (context, state) {
          return IconButton(
            icon: const Icon(Icons.save),
            onPressed: state.status == InfoStatus.valid
                ? () {
                    Navigator.pop<StandardInfo>(
                      context,
                      StandardInfo(
                        textInfo: state.textInfo
                            .map((key, value) => MapEntry(key, value.data)),
                        dateInfo: state.dateInfo.map(
                          (key, value) => MapEntry(
                            key,
                            PrivateData<DateTime>(
                              value.data.data!,
                              private: value.data.private,
                            ),
                          ),
                        ),
                        boolInfo: state.boolInfo
                            .map((key, value) => MapEntry(key, value.data)),
                      ),
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}

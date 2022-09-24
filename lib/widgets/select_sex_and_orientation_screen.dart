import 'package:datingfoss/bloc_common/select_sex_and_orientation_cubit/select_sex_and_orientation_cubit.dart';
import 'package:datingfoss/utils/range_values_extension.dart';
import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:datingfoss/widgets/privatizable_searching_slider.dart';
import 'package:datingfoss/widgets/privatizable_sex_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart' as models;

class SelectSexAndOrientationScreen extends StatelessWidget {
  const SelectSexAndOrientationScreen({
    super.key,
    required this.selectSexAndOrientationCubit,
    this.submitButton,
    this.appBarButton,
  });

  final SelectSexAndOrientationCubit selectSexAndOrientationCubit;
  final Widget? submitButton;
  final Widget? appBarButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarExtension(
        backButton: true,
        context: context,
        titleText: 'Your Sex',
        subtitleText: 'And Orientation',
        actionButton: appBarButton,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Text(
                    'Sex :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<SelectSexAndOrientationCubit,
                      SelectSexAndOrientationState>(
                    bloc: selectSexAndOrientationCubit,
                    builder: (context, state) {
                      return PrivatizableSexSlider(
                        initialValue: state.sex,
                        onSexChanged: (sex) {
                          selectSexAndOrientationCubit.sexChanged(sex: sex);
                        },
                        onPrivateChanged: (private) {
                          selectSexAndOrientationCubit.sexChanged(
                            private: private,
                          );
                        },
                      );
                    },
                  ),
                  const Divider(),
                  const Text(
                    'Searching :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<SelectSexAndOrientationCubit,
                      SelectSexAndOrientationState>(
                    bloc: selectSexAndOrientationCubit,
                    builder: (context, state) {
                      return PrivatizableSearchingSlider(
                        initialValue: models.PrivateData(
                          state.searching.data.materialRangeValues,
                          private: state.searching.private,
                        ),
                        onSearchingChanged: (searching) {
                          selectSexAndOrientationCubit.searchingChanged(
                            searching:
                                _fromMaterialRangeValueToModel(searching),
                          );
                        },
                        onPrivateChanged: (private) {
                          selectSexAndOrientationCubit.searchingChanged(
                            private: private,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            submitButton ?? Container(),
          ],
        ),
      ),
    );
  }

  models.RangeValues _fromMaterialRangeValueToModel(RangeValues? range) {
    if (range == null) return const models.RangeValues(0, 1);
    return models.RangeValues(range.start, range.end);
  }
}

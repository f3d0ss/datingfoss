import 'package:datingfoss/bloc_common/select_standard_info_cubit/select_standard_info_cubit.dart';
import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:datingfoss/widgets/insert_new_filed.dart';
import 'package:datingfoss/widgets/privatizable_bool_form_field.dart';
import 'package:datingfoss/widgets/privatizable_date_picker.dart';
import 'package:datingfoss/widgets/privatizable_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class SelectStandardInfoScreen extends StatelessWidget {
  const SelectStandardInfoScreen({
    super.key,
    required this.selectStandardInfoCubit,
    this.appBarButton,
    this.submitButton,
  });

  final SelectStandardInfoCubit selectStandardInfoCubit;
  final Widget? appBarButton;
  final Widget? submitButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: selectStandardInfoCubit,
      child: Scaffold(
        appBar: AppBarExtension(
          backButton: true,
          titleText: 'Add Your Info',
          subtitleText: 'Please do it',
          context: context,
          actionButton: appBarButton,
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<SelectStandardInfoCubit, SelectStandardInfoState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          child: ListTextInfo(textInfo: state.textInfo),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          child: ListDateInfo(dateInfo: state.dateInfo),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 4,
                          ),
                          child: ListBoolInfo(boolInfo: state.boolInfo),
                        ),
                      ],
                    ),
                  );
                },
              ),
              submitButton ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivatizableInputWrappedInDismissible extends StatelessWidget {
  const PrivatizableInputWrappedInDismissible({
    required this.id,
    required this.child,
    super.key,
  });

  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text('Do you want to remove the $id?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<SelectStandardInfoCubit>().infoRemoved(id);
      },
      child: child,
    );
  }
}

class ListTextInfo extends StatelessWidget {
  const ListTextInfo({
    required this.textInfo,
    super.key,
  });

  final Map<String, TextInfo> textInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Text Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () async {
                final inputToBeAdd = await showDialog<String>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('What do you want to add?'),
                    children: [InsertNewField()],
                  ),
                );
                if (inputToBeAdd != null) {
                  context.read<SelectStandardInfoCubit>().textInfoAdded(
                        inputToBeAdd,
                      );
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...textInfo
            .map(
              (key, value) =>
                  MapEntry<String, PrivatizableInputWrappedInDismissible>(
                key,
                PrivatizableInputWrappedInDismissible(
                  id: key,
                  child: _buildTextField(
                    key,
                    value.data,
                    context.read<SelectStandardInfoCubit>(),
                  ),
                ),
              ),
            )
            .values,
      ],
    );
  }

  PrivatizableTextFormField _buildTextField(
    String key,
    PrivateData<String> data,
    SelectStandardInfoCubit addStandardInfoCubit,
  ) {
    return PrivatizableTextFormField(
      initialValue: data,
      labelText: key,
      onTextChanged: (selectedText) {
        addStandardInfoCubit.textInfoChanged(
          key,
          data: selectedText,
        );
      },
      onPrivateChanged: (private) {
        addStandardInfoCubit.textInfoChanged(
          key,
          private: private,
        );
      },
    );
  }
}

class ListDateInfo extends StatelessWidget {
  const ListDateInfo({
    required this.dateInfo,
    super.key,
  });

  final Map<String, DateInfo> dateInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Date Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () async {
                final inputToBeAdd = await showDialog<String>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('What do you want to add?'),
                    children: [InsertNewField()],
                  ),
                );
                if (inputToBeAdd != null) {
                  context.read<SelectStandardInfoCubit>().dateInfoAdded(
                        inputToBeAdd,
                      );
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...dateInfo
            .map(
              (key, value) =>
                  MapEntry<String, PrivatizableInputWrappedInDismissible>(
                key,
                PrivatizableInputWrappedInDismissible(
                  id: key,
                  child: _buildDataPicker(
                    key,
                    value.data,
                    context.read<SelectStandardInfoCubit>(),
                  ),
                ),
              ),
            )
            .values,
      ],
    );
  }

  PrivatizableDatePicker _buildDataPicker(
    String key,
    PrivateData<DateTime?> data,
    SelectStandardInfoCubit addStandardInfoCubit,
  ) {
    return PrivatizableDatePicker(
      initialValue: data,
      labelText: key,
      onDateChanged: (selectedDate) {
        addStandardInfoCubit.dateInfoChanged(
          key,
          data: selectedDate,
        );
      },
      onPrivateChanged: (private) {
        addStandardInfoCubit.dateInfoChanged(
          key,
          private: private,
        );
      },
    );
  }
}

class ListBoolInfo extends StatelessWidget {
  const ListBoolInfo({
    required this.boolInfo,
    super.key,
  });

  final Map<String, BoolInfo> boolInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Boolean Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () async {
                final inputToBeAdd = await showDialog<String>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('What do you want to add?'),
                    children: [InsertNewField()],
                  ),
                );
                if (inputToBeAdd != null) {
                  context.read<SelectStandardInfoCubit>().boolInfoAdded(
                        inputToBeAdd,
                      );
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...boolInfo
            .map(
              (key, value) =>
                  MapEntry<String, PrivatizableInputWrappedInDismissible>(
                key,
                PrivatizableInputWrappedInDismissible(
                  id: key,
                  child: _buildBoolField(
                    key,
                    value.data,
                    context.read<SelectStandardInfoCubit>(),
                  ),
                ),
              ),
            )
            .values,
      ],
    );
  }

  PrivatizableBoolFormField _buildBoolField(
    String key,
    PrivateData<bool> data,
    SelectStandardInfoCubit addStandardInfoCubit,
  ) {
    return PrivatizableBoolFormField(
      initialValue: data,
      labelBool: key,
      onBoolChanged: (selectedBool) {
        addStandardInfoCubit.boolInfoChanged(key, data: selectedBool);
      },
      onPrivateChanged: (private) {
        addStandardInfoCubit.boolInfoChanged(key, private: private);
      },
    );
  }
}

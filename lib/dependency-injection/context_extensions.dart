import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

extension BuildContextExtensions on BuildContext {
  T buildBloc<T extends Bloc<dynamic, dynamic>>({
    dynamic param1,
    dynamic param2,
  }) {
    final ret = GetIt.instance.get<T>(param1: param1, param2: param2);
    return ret;
  }

  T buildCubit<T extends Cubit<dynamic>>() {
    final ret = GetIt.instance.get<T>();
    return ret;
  }
}

import 'package:equatable/equatable.dart';

class PrivateData<T> extends Equatable {
  const PrivateData(this.data, {this.private = false});

  final T data;
  final bool private;

  PrivateData<T> copyWith({
    T? data,
    bool? private,
  }) {
    return PrivateData(
      data ?? this.data,
      private: private ?? this.private,
    );
  }

  T? getIf({required bool ifPrivate}) => private == ifPrivate ? data : null;

  @override
  List<Object?> get props => [data, private];
}

part of 'add_pictures_cubit.dart';

class AddPicturesState extends Equatable {
  const AddPicturesState({
    this.pictures = const [],
    this.status = PicturesStatus.valid,
  });

  final List<File> pictures;
  final PicturesStatus status;

  AddPicturesState copyWith({
    List<File>? pictures,
    PicturesStatus? status,
  }) {
    return AddPicturesState(
      pictures: pictures ?? this.pictures,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [pictures, status];
}

enum PicturesStatus {
  valid,
  warning,
  addPicture,
  submitted,
}

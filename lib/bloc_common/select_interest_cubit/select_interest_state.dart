part of 'select_interest_cubit.dart';

class SelectInterestState extends Equatable {
  SelectInterestState({
    required this.private,
    List<Interest> initInterests = const [],
    this.status = InterestStatus.valid,
  }) : interests = [...initInterests] {
    standardInterests.removeWhere(
      (stdInterest) =>
          interests.any((interest) => stdInterest == interest.interestName),
    );
    interests.addAll(standardInterests.map((e) => Interest(interestName: e)));
  }

  final bool private;
  final List<Interest> interests;
  final InterestStatus status;
  final standardInterests = [
    'Photography',
    'Shopping',
    'Karaoke',
    'Basketball',
    'Tennis',
    'Drink',
    'Travel',
    'Art',
    'Video games',
    'Music',
    'Work',
    'Adventure',
    'Tatoo',
    'Books',
    'Movies',
    'Sports',
    'Hiking',
    'Beer',
    'Pizza',
    'Family',
    'Laugh',
  ];

  SelectInterestState copyWith({
    List<Interest>? interests,
    InterestStatus? status,
  }) {
    return SelectInterestState(
      private: private,
      initInterests: interests ?? this.interests,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [interests, status];
}

enum InterestStatus {
  valid,
  warning,
  submitted,
}

class Interest extends Equatable {
  const Interest({
    required this.interestName,
    this.isSelected = false,
  });

  final String interestName;
  final bool isSelected;

  Interest copyWith({
    String? interestName,
    bool? isSelected,
  }) {
    return Interest(
      interestName: interestName ?? this.interestName,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [interestName, isSelected];
}

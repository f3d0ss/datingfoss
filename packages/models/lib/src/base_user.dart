import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

part 'base_user.g.dart';

@JsonSerializable()
class BaseUser extends Equatable {
  const BaseUser({
    required this.username,
    required this.publicInfo,
    this.privateInfoBase,
  });

  factory BaseUser.fromJson(Map<String, dynamic> json) =>
      _$BaseUserFromJson(json);

  final String username;
  final PublicInfo publicInfo;
  final PrivateInfo? privateInfoBase;

  Map<String, dynamic> toJson() => _$BaseUserToJson(this);

  bool get hasPrivateInfo => privateInfoBase != null;

  int? get age {
    late DateTime birthdate;
    if (publicInfo.dateInfo['birthdate'] != null) {
      birthdate = publicInfo.dateInfo['birthdate']!;
    } else if (hasPrivateInfo &&
        privateInfoBase!.dateInfo['birthdate'] != null) {
      birthdate = privateInfoBase!.dateInfo['birthdate']!;
    } else {
      return null;
    }
    final days = DateTime.now().difference(birthdate).inDays;
    return (days / 365).round();
  }

  String get privateBioOrPublicBio {
    late String bio;
    if (hasPrivateInfo &&
        privateInfoBase!.bio != null &&
        privateInfoBase!.bio!.isNotEmpty) {
      bio = privateInfoBase!.bio!;
    } else {
      bio = publicInfo.bio;
    }
    return bio;
  }

  static const empty = BaseUser(
    username: '-',
    publicInfo: PublicInfo.empty,
    privateInfoBase: PrivateInfo.empty,
  );

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == BaseUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != BaseUser.empty;

  String? get name {
    if (hasPrivateInfo) {
      if (privateInfoBase!.textInfo['name'] != null) {
        return privateInfoBase!.textInfo['name']!;
      }
    }
    if (publicInfo.textInfo['name'] != null) {
      return publicInfo.textInfo['name']!;
    }
    return null;
  }

  String? get surname {
    if (hasPrivateInfo) {
      if (privateInfoBase!.textInfo['surname'] != null) {
        return privateInfoBase!.textInfo['surname']!;
      }
    }
    if (publicInfo.textInfo['surname'] != null) {
      return publicInfo.textInfo['surname']!;
    }
    return null;
  }

  Map<String, PrivateData<String>> get textInfo {
    final textInfo = <String, PrivateData<String>>{};
    if (hasPrivateInfo) {
      privateInfoBase!.textInfo.forEach((key, value) {
        textInfo.putIfAbsent(
          key,
          () => PrivateData<String>(value, private: true),
        );
      });
    }
    publicInfo.textInfo.forEach((key, value) {
      textInfo.putIfAbsent(
        key,
        () => PrivateData<String>(value),
      );
    });
    return textInfo;
  }

  Map<String, PrivateData<DateTime>> get dateInfo {
    final dateInfo = <String, PrivateData<DateTime>>{};
    if (hasPrivateInfo) {
      privateInfoBase!.dateInfo.forEach((key, value) {
        dateInfo.putIfAbsent(
          key,
          () => PrivateData<DateTime>(value, private: true),
        );
      });
    }
    publicInfo.dateInfo.forEach((key, value) {
      dateInfo.putIfAbsent(
        key,
        () => PrivateData<DateTime>(value),
      );
    });
    return dateInfo;
  }

  Map<String, PrivateData<bool>> get boolInfo {
    final boolInfo = <String, PrivateData<bool>>{};
    if (hasPrivateInfo) {
      privateInfoBase!.boolInfo.forEach((key, value) {
        boolInfo.putIfAbsent(
          key,
          () => PrivateData<bool>(value, private: true),
        );
      });
    }
    publicInfo.boolInfo.forEach((key, value) {
      boolInfo.putIfAbsent(
        key,
        () => PrivateData<bool>(value),
      );
    });
    return boolInfo;
  }

  List<PrivateData<String>> get interests {
    final interests = <PrivateData<String>>[];
    if (hasPrivateInfo) {
      for (final interest in privateInfoBase!.interests) {
        interests.add(PrivateData<String>(interest, private: true));
      }
    }
    for (final interest in publicInfo.interests) {
      if (interests.every((element) => element.data != interest)) {
        interests.add(PrivateData<String>(interest));
      }
    }
    return interests;
  }

  PrivateData<double>? get sex {
    if (privateInfoBase != null && privateInfoBase!.sex != null) {
      return PrivateData(privateInfoBase!.sex!, private: true);
    } else if (publicInfo.sex != null) {
      return PrivateData(publicInfo.sex!);
    } else {
      return null;
    }
  }

  PrivateData<RangeValues>? get searching {
    if (privateInfoBase != null && privateInfoBase!.searching != null) {
      return PrivateData(privateInfoBase!.searching!, private: true);
    } else if (publicInfo.searching != null) {
      return PrivateData(publicInfo.searching!);
    } else {
      return null;
    }
  }

  PrivateData<LatLng>? get location {
    if (privateInfoBase != null && privateInfoBase!.location != null) {
      return PrivateData(privateInfoBase!.location!, private: true);
    } else if (publicInfo.location != null) {
      return PrivateData(publicInfo.location!);
    } else {
      return null;
    }
  }

  List<CommonableInterest> commonableInterest(List<String> inputInterests) {
    final _inputInterest = inputInterests.map((e) => e.toLowerCase());
    final interests = <CommonableInterest>[];
    if (hasPrivateInfo) {
      for (final interest in privateInfoBase!.interests) {
        if (_inputInterest.contains(interest.toLowerCase())) {
          interests
              .add(CommonableInterest(interest, common: true, private: true));
        } else {
          interests
              .add(CommonableInterest(interest, common: false, private: true));
        }
      }
    }
    for (final interest in publicInfo.interests) {
      if (interests.every((element) => element.data != interest)) {
        if (_inputInterest.contains(interest.toLowerCase())) {
          interests.add(CommonableInterest(interest, common: true));
        } else {
          interests.add(CommonableInterest(interest, common: false));
        }
      }
    }
    return interests;
  }

  @override
  List<Object?> get props => [username, publicInfo, privateInfoBase];
}

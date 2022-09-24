import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/discover/discover_card/view/bio_info.dart';
import 'package:datingfoss/discover/discover_card/view/interests_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class BottomInformation extends StatelessWidget {
  const BottomInformation({
    required Partner partner,
    required int index,
    required double? distance,
    super.key,
  })  : _partner = partner,
        _index = index,
        _distance = distance;

  final Partner _partner;
  final int _index;
  final double? _distance;

  @override
  Widget build(BuildContext context) {
    const nameTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
      shadows: [
        Shadow(
          blurRadius: 14,
        ),
      ],
    );
    const ageTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
      color: Colors.white,
      decorationThickness: 2,
      backgroundColor: Colors.white70,
      shadows: [
        Shadow(
          blurRadius: 5,
        ),
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.black54,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          _partner.name ?? _partner.username,
                          style: nameTextStyle,
                          overflow: TextOverflow.fade,
                        ),
                        Text(
                          _partner.age != null ? '${_partner.age}' : '',
                          style: ageTextStyle,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _distance != null
                          ? '${_distance!.toStringAsFixed(2)} Km'
                          : 'No distance',
                      style: ageTextStyle,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _chooseInfoToShow(partner: _partner, index: _index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chooseInfoToShow({required Partner partner, required int index}) {
    switch (index) {
      case 0:
        return BioInfo(bio: partner.publicInfo.bio);
      case 1:
        return BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            final localInterest =
                state.user.interests.map((e) => e.data).toList();
            return InterestsInfo(
              commonableInterest: partner.commonableInterest(localInterest),
            );
          },
        );
      default:
        return BioInfo(bio: partner.privateBioOrPublicBio);
    }
  }
}

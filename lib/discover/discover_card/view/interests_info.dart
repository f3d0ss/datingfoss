import 'package:datingfoss/utils/icons_extension.dart';
import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class InterestsInfo extends StatelessWidget {
  const InterestsInfo({
    required List<CommonableInterest> commonableInterest,
    super.key,
  }) : _commonInterest = commonableInterest;

  final List<CommonableInterest> _commonInterest;

  @override
  Widget build(BuildContext context) {
    final totalInterests = _commonInterest.length;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              (totalInterests / 2).round(),
              (index) => SingleInterest(interest: _commonInterest[index * 2]),
            ),
          ),
          Row(
            children: List.generate(
              (totalInterests / 2).floor(),
              (index) {
                if (index * 2 + 1 < _commonInterest.length) {
                  return SingleInterest(
                    interest: _commonInterest[index * 2 + 1],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SingleInterest extends StatelessWidget {
  const SingleInterest({
    super.key,
    required this.interest,
  });

  final CommonableInterest interest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 9,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: interest.common
              ? Theme.of(context).colorScheme.primary
              : interest.private
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.surfaceVariant,
          boxShadow: const [BoxShadow(blurRadius: 5)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Icon(
                IconsExtension.selectIconFromInterest(
                  interest.data,
                ),
              ),
              Text(
                interest.data.capitalize(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: interest.common
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

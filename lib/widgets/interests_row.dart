import 'package:datingfoss/utils/icons_extension.dart';
import 'package:datingfoss/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class IterestsRow extends StatelessWidget {
  const IterestsRow({super.key, required this.interests});

  final List<CommonableInterest> interests;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        (interests.length / 2).ceil(),
        (index) {
          final firstInterest = interests[index * 2];
          CommonableInterest? secondInterest;
          if (index * 2 + 1 < interests.length) {
            secondInterest = interests[index * 2 + 1];
          }
          return Flex(
            direction: Axis.horizontal,
            children: [
              SingleInterest(interest: firstInterest),
              if (secondInterest != null)
                SingleInterest(interest: secondInterest),
            ],
          );
        },
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
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
                Expanded(
                  child: Text(
                    interest.data.capitalize(),
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      color: interest.common
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

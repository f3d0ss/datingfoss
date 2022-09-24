import 'package:datingfoss/bloc_common/select_interest_cubit/select_interest_cubit.dart';
import 'package:datingfoss/utils/icons_extension.dart';
import 'package:datingfoss/widgets/insert_new_filed.dart';
import 'package:flutter/material.dart';

class SelectInterests extends StatelessWidget {
  const SelectInterests({
    super.key,
    required this.interests,
    required this.onInterestSelected,
    required this.onNewInterestAdded,
  });

  final List<Interest> interests;
  final void Function(String) onInterestSelected;
  final void Function(String) onNewInterestAdded;

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            childAspectRatio: 3 / 1,
            crossAxisCount: landscape ? 4 : 2,
            children: List.generate(interests.length + 1, (index) {
              if (index < interests.length) {
                final interest = interests[index];
                return InterestButton(
                  interest: interest,
                  onInterestSelected: onInterestSelected,
                );
              } else {
                return AddNewInterestButton(
                    onNewInterestAdded: onNewInterestAdded,);
              }
            }),
          ),
        ),
      ),
    );
  }
}

class AddNewInterestButton extends StatelessWidget {
  const AddNewInterestButton({
    super.key,
    required this.onNewInterestAdded,
  });

  final void Function(String p1) onNewInterestAdded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.surfaceVariant,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        onPressed: () async {
          final newInterest = await _showDialogAddInterest(context);
          if (newInterest != null) onNewInterestAdded(newInterest);
        },
        child: Row(
          children: const [
            Icon(Icons.add),
            Text('Add'),
          ],
        ),
      ),
    );
  }

  Future<String?> _showDialogAddInterest(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("What's your interest?"),
        children: [InsertNewField()],
      ),
    );
  }
}

class InterestButton extends StatelessWidget {
  const InterestButton({
    super.key,
    required this.interest,
    required this.onInterestSelected,
  });

  final Interest interest;
  final void Function(String p1) onInterestSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: interest.isSelected
              ? MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                )
              : MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.surfaceVariant,
                ),
          foregroundColor: interest.isSelected
              ? MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                )
              : MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        onPressed: () => onInterestSelected(interest.interestName),
        child: Row(
          children: [
            Icon(
              IconsExtension.selectIconFromInterest(
                interest.interestName,
              ),
            ),
            Expanded(
              child: Text(
                interest.interestName,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

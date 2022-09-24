import 'package:datingfoss/widgets/app_bar_extension.dart';
import 'package:flutter/material.dart';

class SelectBio extends StatefulWidget {
  const SelectBio({
    required this.private,
    this.bio,
    super.key,
    this.appBarButton,
    this.submitButton,
  });

  final bool private;
  final String? bio;
  final Widget Function(TextEditingController)? appBarButton;
  final Widget Function(TextEditingController)? submitButton;

  @override
  State<SelectBio> createState() => _SelectBioState();
}

class _SelectBioState extends State<SelectBio> {
  late TextEditingController myController;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    myController = TextEditingController(text: widget.bio);
  }

  @override
  Widget build(BuildContext context) {
    final appBarButton = widget.appBarButton;
    final submitButton = widget.submitButton;
    return Scaffold(
      appBar: AppBarExtension(
        backButton: true,
        context: context,
        titleText: 'Add Your Bio',
        subtitleText: widget.private ? 'Private' : 'Public',
        actionButton: appBarButton != null ? appBarButton(myController) : null,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: TextField(
                  controller: myController,
                  minLines: 15,
                  maxLines: 15,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                ),
              ),
            ),
            if (submitButton != null) submitButton(myController),
          ],
        ),
      ),
    );
  }
}

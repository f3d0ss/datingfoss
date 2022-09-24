import 'package:datingfoss/widgets/select_bio.dart';
import 'package:flutter/material.dart';

class EditBio extends StatelessWidget {
  const EditBio({
    required this.private,
    required this.bio,
    super.key,
  });

  final bool private;
  final String bio;

  static Route<String> route({
    required bool private,
    required String bio,
  }) {
    return MaterialPageRoute(
      builder: (_) => EditBio(
        private: private,
        bio: bio,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectBio(
      private: private,
      bio: bio,
      appBarButton: (controller) => IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          if (controller.text != '') {
            Navigator.pop<String>(context, controller.text);
          }
        },
      ),
    );
  }
}

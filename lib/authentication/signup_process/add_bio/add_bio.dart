import 'package:datingfoss/authentication/signup_process/widgets/submit_button.dart';
import 'package:datingfoss/widgets/select_bio.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AddBio extends StatelessWidget {
  const AddBio({
    required this.private,
    super.key,
  });

  final bool private;

  @override
  Widget build(BuildContext context) {
    return SelectBio(
      private: private,
      appBarButton: (controller) => IconButton(
        icon: const Icon(Icons.done),
        onPressed: () => onSubmit(context, controller),
      ),
      submitButton: (controller) => SubmitButton(
        onSubmit: () => onSubmit(context, controller),
      ),
    );
  }

  void onSubmit(BuildContext context, TextEditingController controller) {
    if (controller.text != '') {
      if (!private) {
        context.flow<SignupFlowState>().update((state) {
          return state.copyWith(
            bio: controller.text,
            signupStatus: SignupStatus.selectingPrivateBio,
          );
        });
      } else {
        context.flow<SignupFlowState>().update((state) {
          return state.copyWith(
            privateBio: controller.text,
            signupStatus: SignupStatus.selectingPublicPictures,
          );
        });
      }
    }
  }
}

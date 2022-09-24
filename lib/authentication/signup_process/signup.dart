import 'package:datingfoss/authentication/signup_process/add_bio/add_bio.dart';
import 'package:datingfoss/authentication/signup_process/add_interest/add_interest.dart';
import 'package:datingfoss/authentication/signup_process/add_location/add_location.dart';
import 'package:datingfoss/authentication/signup_process/add_pictures/add_pictures.dart';
import 'package:datingfoss/authentication/signup_process/add_sex_and_orientation/add_sex_and_orientation.dart';
import 'package:datingfoss/authentication/signup_process/add_standard_info/add_standard_info.dart';
import 'package:datingfoss/authentication/signup_process/bloc/signup_bloc.dart';
import 'package:datingfoss/authentication/signup_process/signup_credential/signup_credential.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

List<Page<void>> onGenerateProfilePages(
  SignupFlowState signupState,
  List<Page<void>> pages,
) {
  final returnPages = <Page<void>>[
    const MaterialPage<void>(child: SignUpCredential(), name: '/sign-up'),
  ];
  if (signupState.signupStatus == SignupStatus.initial) return returnPages;
  returnPages.add(
    MaterialPage<void>(child: AddLocationScreen()),
  );
  if (signupState.signupStatus == SignupStatus.selectingLocation) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: SelectSexAndOrientation()),
  );
  if (signupState.signupStatus == SignupStatus.selectingSexAndOrientation) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddInfoScreen()),
  );
  if (signupState.signupStatus == SignupStatus.selectingStandardInfo) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddInterest(private: false)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPublicInterests) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddInterest(private: true)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPrivateInterests) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddBio(private: false)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPublicBio) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddBio(private: true)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPrivateBio) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddPictures(private: false)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPublicPictures) {
    return returnPages.toList();
  }
  returnPages.add(
    const MaterialPage<void>(child: AddPictures(private: true)),
  );
  if (signupState.signupStatus == SignupStatus.selectingPrivatePictures) {
    return returnPages.toList();
  }
  throw Exception('Unhandled Signup Flow Status');
}

class SignUpFlow extends StatelessWidget {
  const SignUpFlow({super.key, SignupFlowState? state})
      : state = state ?? const SignupFlowState();

  final SignupFlowState state;
  static Route<SignupFlowState> route() {
    return MaterialPageRoute(builder: (_) => const SignUpFlow());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.buildBloc<SignupBloc>(),
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.signupBlocState == SignupBlocState.signedUp) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (previous, current) =>
            current.signupBlocState != SignupBlocState.signedUp,
        builder: (context, state) {
          if (state.signupBlocState == SignupBlocState.loading) {
            return const LoadingSignup();
          }
          return FlowBuilder<SignupFlowState>(
            state: this.state,
            onGeneratePages: onGenerateProfilePages,
            onComplete: (state) {
              if (state.signupStatus == SignupStatus.completed) {
                context
                    .read<SignupBloc>()
                    .add(SignupRequested(user: state.localUser));
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        },
      ),
    );
  }
}

class LoadingSignup extends StatelessWidget {
  const LoadingSignup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

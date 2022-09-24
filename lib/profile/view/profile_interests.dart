import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/profile/view/editable_interests.dart';
import 'package:datingfoss/widgets/interests_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class PublicProfileInterests extends StatelessWidget {
  const PublicProfileInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final publicInterests = state.user.publicInfo.interests;
        return EditableInterests(
          intialInterests: publicInterests,
          private: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Public Interests',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Icon(Icons.edit)),
                ],
              ),
              IterestsRow(
                interests: publicInterests
                    .map((i) => CommonableInterest(i, common: false))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PrivateProfileInterests extends StatelessWidget {
  const PrivateProfileInterests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final privateInterests = state.user.privateInfo.interests;
        return EditableInterests(
          private: true,
          intialInterests: privateInterests,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Private Interests',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(child: Icon(Icons.edit)),
                ],
              ),
              IterestsRow(
                interests: privateInterests
                    .map(
                      (i) => CommonableInterest(
                        i,
                        common: false,
                        private: true,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

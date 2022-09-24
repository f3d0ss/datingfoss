import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/discover/view/discover_background.dart';
import 'package:datingfoss/discover/view/discover_core.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appBlocState) {
        return BlocProvider(
          create: (context) =>
              context.buildBloc<DiscoverBloc>(param1: appBlocState.user)
                ..add(DiscoverFetchUsersAsked()),
          child: OrientationBuilder(
            builder: (context, orientation) {
              final landscape = orientation == Orientation.landscape;
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          if (landscape)
                            Expanded(
                              child: BlocBuilder<DiscoverBloc, DiscoverState>(
                                builder: (context, state) {
                                  if (state.status == DiscoverStatus.initial ||
                                      state.swipablePartners.length <=
                                          state.frontCardIndex) {
                                    return Container();
                                  }
                                  final username = state
                                      .swipablePartners[state.frontCardIndex]
                                      .username;
                                  return PartnerDetailPage(
                                    key: Key(username),
                                    partnerUsername: username,
                                    keys: state.partnerThatLikeMe[username],
                                  );
                                },
                              ),
                            ),
                          Expanded(
                            child: Stack(
                              children: [
                                if (landscape)
                                  const CustomAppBar()
                                else
                                  const DiscoverBackground(),
                                DiscoverCore(landscape: landscape),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.only(
            left: 20,
          ),
        ),
      ),
    );
  }
}

import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:datingfoss/discover/discover_card/view/discover_card_container.dart';
import 'package:datingfoss/discover/view/discover_swipe_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:tcard/tcard.dart';

class DiscoverCore extends StatelessWidget {
  const DiscoverCore({
    required this.landscape,
    super.key,
  });

  final bool landscape;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ScreenTitle(),
          Expanded(
            child: TCardWithButtonsContainer(
              landscape: landscape,
              key: const Key('TCardWithButtonsContainer'),
            ),
          ),
        ],
      );
}

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.bottomLeft,
        margin: const EdgeInsets.fromLTRB(10, 15, 5, 0),
        child: Text(
          'Discover',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TCardWithButtonsContainer extends StatelessWidget {
  TCardWithButtonsContainer({required this.landscape, super.key});

  final bool landscape;

  final TCardController _tCardController = TCardController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DiscoverBloc, DiscoverState>(
          listenWhen: (previous, current) =>
              current.status != DiscoverStatus.standard,
          listener: _handleSwipe,
        ),
        BlocListener<DiscoverBloc, DiscoverState>(
          listenWhen: (previous, current) =>
              current.swipablePartners != previous.swipablePartners,
          listener: (context, state) => _tCardController.state?.changeCards(
            cards: _buildCards(state.swipablePartners, state.partnerThatLikeMe),
          ),
        ),
      ],
      child: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          const SizedBox(height: 10, width: 30),
          DiscoverSwipeButtons(
            onLikePressed: () {
              context.read<DiscoverBloc>().add(DiscoverLikeButtonPressed());
            },
            onBackPressed: () {
              context.read<DiscoverBloc>().add(DiscoverBackButtonPressed());
            },
            onDiscardPressed: () {
              context.read<DiscoverBloc>().add(DiscoverDiscardButtonPressed());
            },
          ),
          Expanded(child: cardsContainer()),
        ],
      ),
    );
  }

  void _handleSwipe(BuildContext context, DiscoverState state) {
    switch (state.status) {
      case DiscoverStatus.likeing:
        _tCardController.forward(direction: SwipeDirection.Right);
        break;
      case DiscoverStatus.discarding:
        _tCardController.forward(direction: SwipeDirection.Left);
        break;
      case DiscoverStatus.backing:
        _tCardController.back();
        break;
      case DiscoverStatus.initial:
      case DiscoverStatus.standard:
        return;
    }
  }

  Widget cardsContainer() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      buildWhen: (previous, current) =>
          previous.status == DiscoverStatus.initial,
      builder: (context, state) {
        final bloc = context.read<DiscoverBloc>();
        if (state.status == DiscoverStatus.initial) {
          return const SizedBox(
            width: 400,
            height: 500,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return AspectRatio(
            aspectRatio: 5 / 6,
            child: TCard(
              rightIcon: const Icon(
                Icons.delete,
                color: Colors.blue,
                size: 64,
              ),
              leftIcon: const Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 64,
              ),
              cards:
                  _buildCards(state.swipablePartners, state.partnerThatLikeMe),
              controller: _tCardController,
              onForward: (index, info) {
                bloc.add(
                  DiscoverSwiped(
                    direction: info.direction,
                    index: index,
                  ),
                );
              },
              onBack: (index, info) {
                bloc.add(DiscoverBack());
              },
              onEnd: () {},
              frontCardIndex: state.frontCardIndex,
              swipeInfoList: [
                ...state.swipeInfoList
                    .map(discoverSwipeInfoToSwipeInfo)
                    .toList()
              ],
            ),
          );
        }
      },
    );
  }

  List<Widget> _buildCards(
    List<Partner> swipableUsers,
    Map<String, List<String>> likeKeys,
  ) {
    return List.generate(
      swipableUsers.length,
      (int index) {
        final partner = swipableUsers[index];
        return DiscoverCardContainer(
          key: Key('${partner.username}${partner.privateInfo != null}'),
          partner: partner,
          keys: likeKeys[partner.username],
          landscape: landscape,
        );
      },
    );
  }

  SwipeInfo discoverSwipeInfoToSwipeInfo(DiscoverSwipeInfo discoverSwipeInfo) =>
      discoverSwipeInfo.choice == PartnerChoice.like
          ? SwipeInfo(discoverSwipeInfo.partnerIndex, SwipeDirection.Right)
          : SwipeInfo(discoverSwipeInfo.partnerIndex, SwipeDirection.Left);
}

import 'package:datingfoss/app/bloc/app_bloc.dart';
import 'package:datingfoss/dependency-injection/context_extensions.dart';
import 'package:datingfoss/discover/discover_card/bloc/discover_card_bloc.dart';
import 'package:datingfoss/discover/discover_card/view/bottom_information.dart';
import 'package:datingfoss/discover/discover_card/view/card_overlay.dart';
import 'package:datingfoss/discover/discover_card/view/discover_card_background.dart';
import 'package:datingfoss/partner_detail/view/partner_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

class DiscoverCardContainer extends StatelessWidget {
  const DiscoverCardContainer({
    required Partner partner,
    List<String>? keys,
    required bool landscape,
    super.key,
  })  : _partner = partner,
        _landscape = landscape,
        _keys = keys;

  final Partner _partner;
  final List<String>? _keys;
  final bool _landscape;

  static const Image noImageBackground = Image(
    image: AssetImage('assets/images/noImageBackground.png'),
    fit: BoxFit.cover,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appBlocState) {
        return BlocProvider(
          create: (context) => context.buildBloc<DiscoverCardBloc>(
            param1: _partner,
            param2: appBlocState.user,
          )..add(AskedLoadPartner(keys: _keys)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 23,
                  spreadRadius: -13,
                  color: Colors.black54,
                )
              ],
            ),
            child: BlocConsumer<DiscoverCardBloc, DiscoverCardState>(
              listenWhen: (pre, cur) => pre.status != cur.status,
              listener: (context, state) async {
                if (state.status == DiscoverCardStatus.detail) {
                  final bloc = context.read<DiscoverCardBloc>();
                  await Navigator.of(context).push<dynamic>(
                    PartnerDetailScreen.route(
                      partnerUsername: state.partner.username,
                      keys: _keys,
                    ),
                  );
                  bloc.add(ExitedDetailPage());
                }
              },
              builder: (context, state) {
                final backgroundImageId = state.backgroundImageIdFromIndex;
                Image? backgroundImage;
                if (state.pictures.containsKey(backgroundImageId)) {
                  backgroundImage = Image.file(
                    key: Key(backgroundImageId!),
                    state.pictures[backgroundImageId]!,
                    fit: BoxFit.cover,
                  );
                } else if (!state.hasPictures) {
                  backgroundImage = noImageBackground;
                }
                final discoverCardBloc = context.read<DiscoverCardBloc>();
                return Stack(
                  children: [
                    DiscoverCardBackground(
                      backgroundImage: backgroundImage,
                      imageId: backgroundImageId ?? 'noBackground',
                    ),
                    CardOverlay(
                      onTapBottom: _landscape
                          ? null
                          : () => discoverCardBloc.add(BottomTapped()),
                      onTapLeft: () => discoverCardBloc.add(LeftTapped()),
                      onTapRight: () => discoverCardBloc.add(RightTapped()),
                      bottomInformation: BottomInformation(
                        partner: state.partner,
                        index: state.index,
                        distance: state.distance,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:datingfoss/discover/bloc/discover_bloc.dart';
import 'package:datingfoss/discover/bloc/discover_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverSwipeButtons extends StatelessWidget {
  const DiscoverSwipeButtons({
    super.key,
    required this.onDiscardPressed,
    required this.onBackPressed,
    required this.onLikePressed,
  });

  final dynamic Function() onDiscardPressed;
  final dynamic Function() onBackPressed;
  final dynamic Function() onLikePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DiscardButton(onDiscardPressed: onDiscardPressed),
        BackButton(onBackPressed: onBackPressed),
        LikeButton(onLikePressed: onLikePressed),
      ],
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.onLikePressed,
  });

  final dynamic Function() onLikePressed;

  @override
  Widget build(BuildContext context) {
    return DiscoverButton(
      onPressed: onLikePressed,
      icon: const Icon(Icons.favorite),
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
    required this.onBackPressed,
  });

  final dynamic Function() onBackPressed;

  @override
  Widget build(BuildContext context) {
    return DiscoverButton(
      onPressed: onBackPressed,
      icon: const Icon(Icons.refresh),
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

class DiscardButton extends StatelessWidget {
  const DiscardButton({
    super.key,
    required this.onDiscardPressed,
  });

  final dynamic Function() onDiscardPressed;

  @override
  Widget build(BuildContext context) {
    return DiscoverButton(
      onPressed: onDiscardPressed,
      icon: const Icon(Icons.close),
      iconColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}

class DiscoverButton extends StatelessWidget {
  const DiscoverButton({
    super.key,
    required void Function() onPressed,
    required Icon icon,
    required Color iconColor,
  })  : _onPressed = onPressed,
        _icon = icon,
        _iconColor = iconColor;

  final void Function() _onPressed;
  final Icon _icon;
  final Color _iconColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed:
              state.status == DiscoverStatus.standard ? _onPressed : null,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: _iconColor,
            padding: const EdgeInsets.all(24),
          ),
          child: _icon,
        );
      },
    );
  }
}

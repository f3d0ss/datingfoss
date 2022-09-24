import 'package:datingfoss/chat/bloc/chat_bloc.dart';
import 'package:datingfoss/match/bloc/match_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchWidget extends StatelessWidget {
  const MatchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchBloc, MatchState>(
      listenWhen: (previous, current) =>
          current.newMatch != null || current.undoMatch.isNotEmpty,
      listener: (context, state) async {
        final chatBloc = context.read<ChatBloc>();
        final matchBloc = context.read<MatchBloc>();
        if (state.undoMatch.isNotEmpty) {
          chatBloc.add(MatchRemoved(username: state.undoMatch));
        } else {
          chatBloc.add(
            NewMatchFound(
              username: state.newMatch!.username,
              keys: state.newMatch!.keys,
            ),
          );
          await Future<void>.delayed(const Duration(seconds: 5));
          matchBloc.add(TappedNewMatch());
        }
      },
      buildWhen: (previous, current) => previous.newMatch != current.newMatch,
      builder: (context, state) {
        final newMatch = state.newMatch;
        if (newMatch != null) {
          return NewMatchAnimation(newMatch: newMatch.username);
        } else {
          return Container();
        }
      },
    );
  }
}

class NewMatchAnimation extends StatelessWidget {
  const NewMatchAnimation({
    required this.newMatch,
    super.key,
  });

  final String newMatch;
  Color topBackgroundColor(BuildContext context) =>
      bottomBackgroundColor(context);
  Color bottomBackgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  double ease(double a) {
    // bouncing transformation
    const n1 = 7.5625;
    const d1 = 2.75;
    var newFraction = a;

    if (newFraction < 1 / d1) {
      return n1 * newFraction * newFraction;
    } else if (newFraction < 2 / d1) {
      newFraction -= 1.5 / d1;
      return n1 * newFraction * newFraction + 0.75;
    } else if (newFraction < 2.5 / d1) {
      newFraction -= 2.25 / d1;
      return n1 * newFraction * newFraction + 0.9375;
    } else {
      newFraction -= 2.625 / d1;
      return n1 * newFraction * newFraction + 0.984375;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MatchBloc>().add(TappedNewMatch()),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          value = ease(value);
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  bottomBackgroundColor(context).withAlpha(255),
                  topBackgroundColor(context).withAlpha((value * 240).round()),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: RadiantGradientMask(
                      child: Icon(
                        Icons.favorite,
                        shadows: const <Shadow>[Shadow(blurRadius: 15)],
                        color: Colors.white,
                        size: value * 250,
                      ),
                    ),
                  ),
                  Text(
                    'MATCH',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50 * value,
                      shadows: const <Shadow>[Shadow(blurRadius: 5)],
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const RadialGradient(
        colors: [Colors.red, Color.fromARGB(255, 150, 13, 13)],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}

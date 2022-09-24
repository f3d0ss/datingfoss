import 'package:flutter/material.dart';

class CardOverlay extends StatelessWidget {
  const CardOverlay({
    void Function()? onTapLeft,
    void Function()? onTapRight,
    void Function()? onTapBottom,
    Widget? bottomInformation,
    super.key,
  })  : _onTapLeft = onTapLeft,
        _onTapRight = onTapRight,
        _onTapBottom = onTapBottom,
        _bottomInformation = bottomInformation;

  final void Function()? _onTapLeft;
  final void Function()? _onTapRight;
  final void Function()? _onTapBottom;
  final Widget? _bottomInformation;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: GestureDetector(
                    onTap: _onTapLeft,
                    child: const ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: double.infinity,
                  child: GestureDetector(
                    onTap: _onTapRight,
                    child: const ColoredBox(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _onTapBottom,
            child: _bottomInformation,
          ),
        ),
      ],
    );
  }
}

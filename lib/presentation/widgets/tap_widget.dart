import 'package:flutter/material.dart';

class TapWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onHover;
  final Widget child;

  final String? tooltip;

  const TapWidget(
      {super.key, required this.child, this.onTap, this.onHover, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: MouseRegion(
          cursor: onTap == null
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onEnter: (event) {
            onHover?.call();
          },
          onExit: (event) {
            onHover?.call();
          },
          child: GestureDetector(
            onTap: onTap,
            child: child,
          )),
    );
  }
}

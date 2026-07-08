import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jaga_saku/core/core.dart';

class ColorLoader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  const ColorLoader({super.key, this.radius = 30.0, this.dotRadius = 6.0});

  @override
  State<ColorLoader> createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animationRotation;
  late final Animation<double> animationRadiusIn;
  late final Animation<double> animationRadiusOut;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 1.0)),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.repeat();
  }

  /// Pulsing radius derived from the controller. Computed per-frame inside
  /// [AnimatedBuilder] rather than via `setState()` in a listener, so only the
  /// dot [Stack] repaints each frame — not the whole widget subtree.
  double get _radius {
    final value = controller.value;
    if (value >= 0.75) return widget.radius * animationRadiusIn.value;
    if (value <= 0.25) return widget.radius * animationRadiusOut.value;
    return widget.radius;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 100.0,
    height: 100.0,
    child: Center(
      child: RotationTransition(
        turns: animationRotation,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final radius = _radius;
            return Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset.zero,
                  child: Dot(radius: radius, color: Colors.black26),
                ),
                Transform.translate(
                  offset: Offset(radius * cos(0.0), radius * sin(0.0)),
                  child: Dot(radius: widget.dotRadius, color: Palette.primary),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 1 * pi / 4),
                    radius * sin(0.0 + 1 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: Palette.secondary,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 2 * pi / 4),
                    radius * sin(0.0 + 2 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.red,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 3 * pi / 4),
                    radius * sin(0.0 + 3 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.yellow,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 4 * pi / 4),
                    radius * sin(0.0 + 4 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.green,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 5 * pi / 4),
                    radius * sin(0.0 + 5 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.flamingo,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 6 * pi / 4),
                    radius * sin(0.0 + 6 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.lavender,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                    radius * cos(0.0 + 7 * pi / 4),
                    radius * sin(0.0 + 7 * pi / 4),
                  ),
                  child: Dot(
                    radius: widget.dotRadius,
                    color: context.colors.pink,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  const Dot({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

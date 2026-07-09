import 'package:flutter/material.dart';
import 'package:jaga_saku/core/resources/resources.dart';

/// Slides a gradient horizontally so [Shimmer] sweeps left-to-right.
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}

/// Masks [child] with an animated gradient sweep. Pair with [SkeletonBox]
/// placeholders to build skeleton loading states (see [ListSkeleton]).
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.1, 0.3, 0.4],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: _SlidingGradientTransform(_controller.value * 3 - 1),
        ).createShader(bounds),
        child: child,
      ),
    );
  }
}

/// A solid rounded placeholder block; recoloured by an ancestor [Shimmer].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    this.height = 14,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      // Any opaque colour works — the Shimmer ShaderMask paints over it.
      color: Colors.white,
      shape: shape,
      borderRadius: shape == BoxShape.circle
          ? null
          : BorderRadius.circular(borderRadius),
    ),
  );
}

/// A shimmering placeholder for an avatar + two-line list (mirrors the users
/// dashboard rows). Drop in while a list is loading.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({this.itemCount = 8, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) => Shimmer(
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: itemCount,
      itemBuilder: (context, _) => const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            SkeletonBox(width: 46, height: 46, shape: BoxShape.circle),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 140),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(width: 200, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

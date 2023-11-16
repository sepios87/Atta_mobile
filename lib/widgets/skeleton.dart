import 'package:flutter/material.dart';

/// Skeleton widget.
class AttaSkeleton extends StatefulWidget {
  /// Default constructor.
  const AttaSkeleton({super.key, this.size, this.borderRadius});

  /// Size of the skeleton.
  final Size? size;

  /// Border radius of the skeleton.
  final BorderRadiusGeometry? borderRadius;

  @override
  State<AttaSkeleton> createState() => _AttaSkeletonState();
}

class _AttaSkeletonState extends State<AttaSkeleton> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);

  final _skeletonColors = [
    TweenSequenceItem<Color?>(
      weight: 1,
      tween: ColorTween(
        begin: const Color.fromARGB(255, 242, 242, 242),
        end: const Color.fromARGB(255, 208, 208, 208),
      ),
    ),
  ];

  late final _animation = TweenSequence(_skeletonColors).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.size?.width,
          height: widget.size?.height,
          decoration: BoxDecoration(
            color: _animation.value,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

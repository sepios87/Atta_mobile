part of '../preload_page.dart';

class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    value: 2,
  );

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  final _tween = Tween<double>(begin: 0.5, end: 1);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (_animation.isDisposed) return;
      try {
        _animationController
          ..forward()
          ..repeat(reverse: true);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: ScaleTransition(
        scale: _tween.animate(_animation),
        child: Image.asset(
          'assets/logo/full.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }
}

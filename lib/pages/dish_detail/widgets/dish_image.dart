part of '../dish_detail_page.dart';

class _DishImage extends StatefulWidget {
  const _DishImage({required this.imageUrl});

  final String imageUrl;

  @override
  State<_DishImage> createState() => __DishImageState();
}

class __DishImageState extends State<_DishImage> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastEaseInToSlowEaseOut,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.sizeOf(context).width - 36 - AttaSpacing.m; // 36 = button width + margin

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.4, 0.6),
          end: Offset.zero,
        ).animate(_animation),
        child: ScaleTransition(
          scale: _animation,
          child: RotationTransition(
            turns: _animation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AttaColors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(-2, 6),
                  ),
                ],
              ),
              child: ClipOval(
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  width: imageSize,
                  height: imageSize,
                  maxWidthDiskCache: 1000,
                  maxHeightDiskCache: 1000,
                  useOldImageOnUrlChange: true,
                  fadeInDuration: AttaAnimation.mediumAnimation,
                  fit: BoxFit.cover,
                  placeholder: (context, _) {
                    return AttaSkeleton(size: Size(imageSize, imageSize));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:atta/screens/preload/cubit/preload_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PreloadScreen extends StatelessWidget {
  const PreloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreloadCubit(),
      child: BlocListener<PreloadCubit, PreloadState>(
        listener: (context, state) {
          if (state.status is PreloadErrorStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.status as PreloadErrorStatus).message,
                ),
              ),
            );
          }
          if (state.status is PreloadLoadedStatus) {
            context.pushReplacement('/home');
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _LogoAnimation(),
                const SizedBox(height: AttaSpacing.xl),
                Text(
                  'Chargement...',
                  style: AttaTextStyle.header.copyWith(
                    color: AttaColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoAnimation extends StatefulWidget {
  const _LogoAnimation();

  @override
  State<_LogoAnimation> createState() => _LogoAnimationState();
}

// TODO(florian): pass in part file
class _LogoAnimationState extends State<_LogoAnimation> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    value: 1,
  );

  late final _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  );

  final _tween = Tween<double>(begin: 0.5, end: 1);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
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

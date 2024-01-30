import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/preload/cubit/preload_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreloadPage {
  static const path = '/';

  static Widget getScreen() => BlocProvider(
        create: (context) => PreloadCubit(),
        child: const _PreloadScreen(),
      );
}

class _PreloadScreen extends StatelessWidget {
  const _PreloadScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PreloadCubit, PreloadState>(
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
            context.adapativeReplacementNamed(HomePage.routeName);
          }
        },
        builder: (context, state) {
          if (state.status is PreloadErrorStatus) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AttaSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: AttaSpacing.xxl),
                    Text(
                      'Une erreur est survenue...',
                      style: AttaTextStyle.header.copyWith(
                        color: AttaColors.white,
                      ),
                    ),
                    const SizedBox(height: AttaSpacing.xxl),
                    ElevatedButton(
                      onPressed: () => context.read<PreloadCubit>().load(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
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
          );
        },
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

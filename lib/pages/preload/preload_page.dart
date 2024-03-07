import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/preload/cubit/preload_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

part 'widgets/animated_logo.dart';

class PreloadPage {
  static const path = '/';

  static Widget getScreen() => BlocProvider(
        create: (context) => PreloadCubit(),
        child: const _PreloadScreen(),
      );
}

class _PreloadScreen extends StatefulWidget {
  const _PreloadScreen();

  @override
  State<_PreloadScreen> createState() => _PreloadScreenState();
}

class _PreloadScreenState extends State<_PreloadScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PreloadCubit>().load(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PreloadCubit, PreloadState>(
        listener: (context, state) {
          final status = state.status;

          if (status is PreloadErrorStatus) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(status.message)),
            );
          }

          if (status is PreloadLoadedStatus) {
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
                      onPressed: () => context.read<PreloadCubit>().load(context),
                      child: Text(translate('preload_page.retry')),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: _AnimatedLogo());
        },
      ),
    );
  }
}

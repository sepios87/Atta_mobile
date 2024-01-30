import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/pages/favorite/cubit/favorite_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/app_bar.dart';
import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FavoritePage {
  static const path = '/favorite';
  static const routeName = 'favorite';

  static Widget getScreen() => BlocProvider(
        create: (context) => FavoriteCubit(),
        child: const _FavoriteScreen(),
      );
}

class _FavoriteScreen extends StatelessWidget {
  const _FavoriteScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AttaAppBar(user: state.user),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusExt.top(AttaRadius.medium),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AttaSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AttaSpacing.m),
                    Text('Vos favoris', style: AttaTextStyle.header),
                    const SizedBox(height: AttaSpacing.m),
                    if (state.favoriteRestaurants.isEmpty) ...[
                      const SizedBox(height: AttaSpacing.s),
                      const Text("Vous n'avez pas encore de favoris"),
                      const SizedBox(height: AttaSpacing.l),
                      ElevatedButton(
                        onPressed: () => context.replaceNamed(HomePage.routeName),
                        child: const Text('Découvrir de nouveaux restaurants'),
                      ),
                    ] else
                      ...state.favoriteRestaurants.map((restaurant) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AttaSpacing.m),
                          child: Text(restaurant.name),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const AttaBottomNavigationBar(),
        );
      },
    );
  }
}

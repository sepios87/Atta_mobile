import 'package:atta/entities/dish.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/favorite/cubit/favorite_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/favorite_button.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';

part 'widgets/favorite_dish.dart';
part 'widgets/favorite_restaurant.dart';

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
    final listRestaurantKey = GlobalKey<AnimatedListState>();
    final listDishKey = GlobalKey<AnimatedListState>();

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final favoriteRestaurants = state.favoriteRestaurants;
        final favoriteDishs = state.favoriteDishs;

        return Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusExt.top(AttaRadius.medium),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AttaSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AttaSpacing.m),
                Text(translate('favorite_page.title'), style: AttaTextStyle.header).withPadding(
                  const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                ),
                const SizedBox(height: AttaSpacing.l),
                if (favoriteRestaurants.isEmpty && favoriteDishs.isEmpty) ...[
                  Text(translate('favorite_page.no_favorite')).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  ElevatedButton(
                    onPressed: () => context.replaceNamed(HomePage.routeName),
                    child: Text(translate('favorite_page.go_to_home')),
                  ).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                ],
                if (favoriteRestaurants.isNotEmpty) ...[
                  Text(translate('favorite_page.restaurants'), style: AttaTextStyle.subHeader).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.m),
                  AnimatedList(
                    key: listRestaurantKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    initialItemCount: favoriteRestaurants.length,
                    itemBuilder: (_, index, animation) {
                      final restaurant = favoriteRestaurants[index];
                      return _FavoriteRestaurant(
                        key: ValueKey(restaurant.id),
                        restaurant: restaurant,
                        animation: animation,
                        onUnlikedDish: () async {
                          await context.read<FavoriteCubit>().onUnlikedRestaurant(restaurant.id);
                          listRestaurantKey.currentState?.removeItem(
                            index,
                            (context, animation) => _FavoriteRestaurant(
                              restaurant: restaurant,
                              animation: animation,
                              // Empty function to show the animation
                              onUnlikedDish: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: AttaSpacing.m),
                ],
                if (favoriteDishs.isNotEmpty) ...[
                  Text(translate('favorite_page.dishes'), style: AttaTextStyle.subHeader).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.xxs),
                  AnimatedList(
                    key: listDishKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    initialItemCount: state.favoriteDishs.length,
                    itemBuilder: (_, index, animation) {
                      final dish = state.favoriteDishs[index];
                      return _FavoriteDish(
                        key: ValueKey('${dish.$1.id}-${dish.$2}'),
                        animation: animation,
                        dish: dish.$1,
                        restaurant: state.getRestaurant(dish.$2),
                        onUnlikedDish: () async {
                          await context.read<FavoriteCubit>().onUnlikedDish(dish.$2, dish.$1.id);
                          listDishKey.currentState?.removeItem(
                            index,
                            (context, animation) => _FavoriteDish(
                              animation: animation,
                              dish: dish.$1,
                              restaurant: state.getRestaurant(dish.$2),
                              // Empty function to show the animation
                              onUnlikedDish: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

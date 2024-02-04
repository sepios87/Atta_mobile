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
import 'package:atta/widgets/app_bar.dart';
import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:atta/widgets/favorite_button.dart';
import 'package:atta/widgets/formula_card.dart';
import 'package:atta/widgets/restaurant_card.dart';
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
        final favoriteRestaurants = state.favoriteRestaurants;
        final favoriteDishs = state.favoriteDishs;

        return Scaffold(
          appBar: AttaAppBar(user: state.user),
          body: Container(
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
                  Text('Vos favoris', style: AttaTextStyle.header).withPadding(
                    const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  ),
                  const SizedBox(height: AttaSpacing.l),
                  if (favoriteRestaurants.isEmpty && favoriteDishs.isEmpty) ...[
                    const Text("Vous n'avez pas encore de favoris").withPadding(
                      const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    ),
                    const SizedBox(height: AttaSpacing.l),
                    ElevatedButton(
                      onPressed: () => context.replaceNamed(HomePage.routeName),
                      child: const Text('Découvrir de nouveaux restaurants'),
                    ).withPadding(
                      const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    ),
                  ],
                  if (favoriteRestaurants.isNotEmpty) ...[
                    Text('Les restaurants', style: AttaTextStyle.subHeader).withPadding(
                      const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    ),
                    const SizedBox(height: AttaSpacing.m),
                    ...favoriteRestaurants.map((restaurant) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AttaSpacing.m,
                          left: AttaSpacing.m,
                          right: AttaSpacing.m,
                        ),
                        child: RestaurantCard(
                          key: ValueKey(restaurant.id),
                          restaurant: restaurant,
                          positionedWidget: Positioned(
                            top: 0,
                            right: 0,
                            child: FavoriteButton(
                              isFavorite: true,
                              onFavoriteChanged: () => context.read<FavoriteCubit>().onUnlikedRestaurant(restaurant.id),
                            ),
                          ),
                          onTap: () => context.adapativePushNamed(
                            RestaurantDetailPage.routeName,
                            pathParameters: RestaurantDetailPageArgument(
                              restaurantId: restaurant.id,
                            ).toPathParameters(),
                          ),
                        ),
                      );
                    }),
                  ],
                  if (favoriteDishs.isNotEmpty) ...[
                    const SizedBox(height: AttaSpacing.m),
                    Text('Les plats', style: AttaTextStyle.subHeader).withPadding(
                      const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                    ),
                    const SizedBox(height: AttaSpacing.xxs),
                    ...state.favoriteDishs.map((dish) {
                      return FormulaCard(
                        key: ValueKey('${dish.$1.id}-${dish.$2}'),
                        formula: dish.$1,
                        badge: FavoriteButton(
                          borderColor: AttaColors.black,
                          isFavorite: true,
                          onFavoriteChanged: () => context.read<FavoriteCubit>().onUnlikedDish(dish.$2, dish.$1.id),
                        ),
                        onTap: () {
                          context
                              .adapativePushNamed<bool>(
                            DishDetailPage.routeName,
                            pathParameters: DishDetailPageArgument(
                              dishId: dish.$1.id,
                              restaurantId: dish.$2,
                            ).toPathParameters(),
                          )
                              .then((value) {
                            if (value != null && value) {
                              context.adapativePushNamed(
                                RestaurantDetailPage.routeName,
                                pathParameters: RestaurantDetailPageArgument(
                                  restaurantId: dish.$2,
                                ).toPathParameters(),
                              );
                            }
                          });
                        },
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: const AttaBottomNavigationBar(),
        );
      },
    );
  }
}

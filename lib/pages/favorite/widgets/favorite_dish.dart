part of '../favorite_page.dart';

class _FavoriteDish extends StatelessWidget {
  const _FavoriteDish({
    required this.animation,
    required this.dish,
    required this.restaurant,
    required this.onUnlikedDish,
    super.key,
  });

  final Animation<double> animation;
  final AttaDish dish;
  final AttaRestaurant restaurant;
  final void Function() onUnlikedDish;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInExpo)).animate(animation),
        child: FormulaCard(
          formula: dish,
          suffixName: '(${restaurant.name})',
          badge: FavoriteButton(
            borderColor: AttaColors.black,
            isFavorite: true,
            onFavoriteChanged: onUnlikedDish,
          ),
          onTap: () {
            context
                .adapativePushNamed<bool>(
              DishDetailPage.routeName,
              pathParameters: DishDetailPageArgument(
                dishId: dish.id,
                restaurantId: restaurant.id,
              ).toPathParameters(),
            )
                .then((value) {
              if (value != null && value) {
                context.adapativePushNamed(
                  RestaurantDetailPage.routeName,
                  pathParameters: RestaurantDetailPageArgument(
                    restaurantId: restaurant.id,
                  ).toPathParameters(),
                );
              }
            });
          },
        ),
      ),
    );
  }
}

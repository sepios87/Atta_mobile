part of '../favorite_page.dart';

class _FavoriteRestaurant extends StatelessWidget {
  const _FavoriteRestaurant({
    required this.restaurant,
    required this.animation,
    required this.onUnlikedDish,
    super.key,
  });

  final AttaRestaurant restaurant;
  final Animation<double> animation;
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
        child: Padding(
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
                onFavoriteChanged: onUnlikedDish,
              ),
            ),
            onTap: () => context.adapativePushNamed(
              RestaurantDetailPage.routeName,
              pathParameters: RestaurantDetailPageArgument(
                restaurantId: restaurant.id,
              ).toPathParameters(),
            ),
          ),
        ),
      ),
    );
  }
}

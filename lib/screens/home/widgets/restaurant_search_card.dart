part of '../home_screen.dart';

class _RestaurantSearchCard extends StatelessWidget {
  const _RestaurantSearchCard({required this.restaurant});

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.push(
            RestaurantDetailPage.path,
            extra: RestaurantDetailScreenArgument(
              restaurantId: restaurant.id,
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.m,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(AttaRadius.small),
            child: Image.network(
              restaurant.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              cacheHeight: 48,
              cacheWidth: 48,
              loadingBuilder: (context, child, loadingProgress) {
                return Skeletonizer(
                  enabled: loadingProgress != null,
                  child: child,
                );
              },
            ),
          ),
          title: Text(
            restaurant.name,
          ),
          subtitle: Text(
            restaurant.category.map((filter) => filter.name).join(', '),
          ),
        ),
      ),
    );
  }
}

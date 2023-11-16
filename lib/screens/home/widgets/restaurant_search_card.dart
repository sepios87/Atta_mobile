part of '../home_screen.dart';

class _RestaurantSearchCard extends StatelessWidget {
  const _RestaurantSearchCard({required this.restaurant});

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.pushNamed(
            RestaurantDetailPage.routeName,
            pathParameters: RestaurantDetailScreenArgument(
              restaurantId: restaurant.id,
            ).toPathParameters(),
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
                if (loadingProgress == null) return child;
                return const AttaSkeleton(size: Size(48, 48));
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

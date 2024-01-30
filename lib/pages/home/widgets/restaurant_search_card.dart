part of '../home_page.dart';

class _RestaurantSearchCard extends StatelessWidget {
  const _RestaurantSearchCard({required this.restaurant});

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.adapativePushNamed(
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
            child: CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              placeholder: (context, _) {
                return const AttaSkeleton(size: Size(48, 48));
              },
            ),
          ),
          title: Text(
            restaurant.name,
          ),
          subtitle: Text(
            restaurant.filters.map((filter) => filter.name).join(', '),
          ),
        ),
      ),
    );
  }
}
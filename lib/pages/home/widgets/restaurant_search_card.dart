part of '../home_page.dart';

class _RestaurantSearchCard extends StatelessWidget {
  const _RestaurantSearchCard({required this.restaurant});

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.adapativePushNamed(
            RestaurantDetailPage.routeName,
            pathParameters: RestaurantDetailPageArgument(
              restaurantId: restaurant.id,
            ).toPathParameters(),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(AttaRadius.small),
            child: CachedNetworkImage(
              imageUrl: restaurant.thumbnail,
              width: 68,
              height: 68,
              maxWidthDiskCache: 1000,
              maxHeightDiskCache: 1000,
              useOldImageOnUrlChange: true,
              fadeInDuration: AttaAnimation.mediumAnimation,
              fit: BoxFit.cover,
              placeholder: (context, _) => const AttaSkeleton(size: Size(68, 68)),
            ),
          ),
          title: Text(restaurant.name, style: AttaTextStyle.label),
          subtitle: Text(
            restaurant.filters.map((filter) => filter.translatedName).join(', '),
          ),
        ),
      ),
    );
  }
}

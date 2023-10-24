part of '../home_screen.dart';

class _RestaurantSearchCard extends StatelessWidget {
  const _RestaurantSearchCard({required this.restaurant});

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.m,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
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
            restaurant.filter.map((filter) => filter.name).join(', '),
          ),
        ),
      ),
    );
  }
}

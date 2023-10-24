part of '../home_screen.dart';

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    this.isFullWidth = false,
    this.positionedWidget,
  });

  final AttaRestaurant restaurant;
  final bool isFullWidth;
  final Positioned? positionedWidget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurant),
      child: SizedBox(
        width: isFullWidth ? null : 128,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
              child: Stack(
                children: [
                  Image.network(
                    restaurant.imageUrl,
                    width: double.infinity,
                    height: 98,
                    fit: BoxFit.cover,
                    cacheHeight: 98,
                    cacheWidth: 128,
                    loadingBuilder: (context, child, loadingProgress) {
                      return Skeletonizer(
                        enabled: loadingProgress != null,
                        child: child,
                      );
                    },
                  ),
                  if (positionedWidget != null)
                    Positioned.fill(
                      child: ColoredBox(
                        color: AttaColors.black.withOpacity(0.3),
                      ),
                    ),
                  if (positionedWidget != null) positionedWidget!,
                ],
              ),
            ),
            const SizedBox(height: AttaSpacing.xxs),
            Flexible(
              child: Text(
                restaurant.name,
                overflow: TextOverflow.ellipsis,
                style: AttaTextStyle.subHeader,
              ),
            ),
            Text(restaurant.filter.first.name, style: AttaTextStyle.content),
          ],
        ),
      ),
    );
  }
}

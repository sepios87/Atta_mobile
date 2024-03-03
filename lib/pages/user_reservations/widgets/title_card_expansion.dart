part of '../user_reservations_page.dart';

class _TitleReservationCardExpansion extends StatelessWidget {
  const _TitleReservationCardExpansion({
    required this.reservation,
    required this.restaurant,
  });

  final AttaReservation reservation;
  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AttaSpacing.s,
        horizontal: AttaSpacing.m,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AttaRadius.small),
              child: CachedNetworkImage(
                imageUrl: restaurant.thumbnail,
                width: 68,
                maxWidthDiskCache: 1000,
                maxHeightDiskCache: 1000,
                useOldImageOnUrlChange: true,
                fit: BoxFit.cover,
                fadeInDuration: AttaAnimation.mediumAnimation,
                imageBuilder: (context, imageProvider) {
                  return Material(
                    child: Ink.image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      child: InkWell(
                        splashColor: AttaColors.black.withOpacity(0.2),
                        onTap: () => context.adapativePushNamed(
                          RestaurantDetailPage.routeName,
                          pathParameters: RestaurantDetailPageArgument(
                            restaurantId: restaurant.id,
                          ).toPathParameters(),
                        ),
                      ),
                    ),
                  );
                },
                placeholder: (context, _) => const AttaSkeleton(size: Size(68, 68)),
              ),
            ),
            const SizedBox(width: AttaSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    overflow: TextOverflow.ellipsis,
                    style: AttaTextStyle.subHeader,
                  ),
                  Text(
                    reservation.dateTime.accurateFormat(),
                    overflow: TextOverflow.ellipsis,
                    style: AttaTextStyle.label.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.xxs),
                  Text(
                    '#${reservation.id}',
                    overflow: TextOverflow.ellipsis,
                    style: AttaTextStyle.caption.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

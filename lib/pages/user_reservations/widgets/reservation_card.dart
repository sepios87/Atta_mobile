part of '../user_reservations_page.dart';

class _ReservationCard extends StatelessWidget {
  const _ReservationCard(this.reservation);

  final AttaReservation reservation;

  @override
  Widget build(BuildContext context) {
    final restaurant = restaurantService.restaurants.firstWhere((r) => r.id == reservation.restaurantId);

    // TODO(florian): add price if dish list is not empty
    return Material(
      child: InkWell(
        onTap: () {
          // TODO(florian): implement (show details page ?)
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AttaSpacing.s,
            horizontal: AttaSpacing.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AttaRadius.small),
                child: CachedNetworkImage(
                  imageUrl: restaurant.imageUrl,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  imageBuilder: (context, imageProvider) {
                    return Material(
                      child: Ink.image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        child: InkWell(
                          splashColor: AttaColors.black.withOpacity(0.2),
                          onTap: () => context.adapativePushNamed(
                            RestaurantDetailPage.routeName,
                            pathParameters: RestaurantDetailScreenArgument(
                              restaurantId: restaurant.id,
                            ).toPathParameters(),
                          ),
                        ),
                      ),
                    );
                  },
                  placeholder: (context, _) {
                    return const AttaSkeleton(size: Size(68, 68));
                  },
                ),
              ),
              const SizedBox(width: AttaSpacing.m),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: AttaTextStyle.subHeader,
                  ),
                  Text(
                    reservation.dateTime.accurateFormat,
                    style: AttaTextStyle.label.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.xxs),
                  Text(
                    '#${reservation.id}',
                    style: AttaTextStyle.caption.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (reservation.tableId != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AttaSpacing.xs,
                    vertical: AttaSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AttaColors.black,
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.table_restaurant_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: AttaSpacing.xxs),
                      Text(
                        reservation.tableId!.toString(),
                        style: AttaTextStyle.label.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

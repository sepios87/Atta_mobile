part of '../cart_page.dart';

class _ReservationCartCard extends StatelessWidget {
  const _ReservationCartCard(this.reservation);

  final AttaReservation reservation;

  @override
  Widget build(BuildContext context) {
    final restaurant = restaurantService.restaurants.firstWhere((r) => r.id == reservation.restaurantId);

    return Material(
      child: InkWell(
        onTap: () async {
          await context.adapativePushNamed(
            RestaurantDetailPage.routeName,
            pathParameters: RestaurantDetailPageArgument(
              restaurantId: restaurant.id,
            ).toPathParameters(),
          );
          // ignore: use_build_context_synchronously
          context.read<CartCubit>().refresh();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AttaSpacing.s,
            horizontal: AttaSpacing.m,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.imageUrl,
                      width: 68,
                      maxWidthDiskCache: 1000,
                      maxHeightDiskCache: 1000,
                      useOldImageOnUrlChange: true,
                      fit: BoxFit.cover,
                      fadeInDuration: AttaAnimation.mediumAnimation,
                      placeholder: (context, _) => const AttaSkeleton(size: Size(68, 68)),
                    ),
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
                      const SizedBox(height: AttaSpacing.xs),
                      ReservationFormulaDetail(reservation, withMenuDetail: false),
                      const SizedBox(height: AttaSpacing.xxs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

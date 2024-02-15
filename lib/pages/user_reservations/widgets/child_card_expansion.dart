part of '../user_reservations_page.dart';

class _ChildReservationTileExpansion extends StatelessWidget {
  const _ChildReservationTileExpansion({
    required this.reservation,
    required this.restaurant,
  });

  final AttaReservation reservation;
  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserReservationsCubit, UserReservationsState>(
      builder: (context, state) {
        final status = state.status;

        if (status is UserReservationsLoading && status.reservationId == reservation.id) {
          return Column(
            children: [
              const SizedBox(height: AttaSpacing.m),
              SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AttaColors.accent),
                  strokeWidth: 2,
                ),
              ),
            ],
          );
        }

        final dishIds = reservation.dishIds.keys;
        final menus = reservation.menus;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 68,
              child: Column(
                children: [
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.table_restaurant_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          const SizedBox(width: AttaSpacing.xs),
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
                  const SizedBox(height: AttaSpacing.xxs),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => MapsLauncher.launchQuery(restaurant.address),
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove margin around the button
                          ),
                      child: Transform.rotate(
                        angle: 0.5,
                        child: const Icon(
                          Icons.navigation_rounded,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AttaSpacing.xxs),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Share.share(reservation.shareText(restaurant)),
                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove margin around the button
                          ),
                      child: const Icon(Icons.share, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            if ((reservation.comment?.isNotEmpty ?? false) || reservation.withFormulas)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (reservation.comment != null && reservation.comment!.isNotEmpty) ...[
                        const SizedBox(width: AttaSpacing.m),
                        Text(
                          'Votre commentaire :',
                          style: AttaTextStyle.subHeader.copyWith(
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: AttaSpacing.xxs),
                        Text(
                          reservation.comment!,
                          style: AttaTextStyle.content.copyWith(
                            color: const Color.fromRGBO(97, 97, 97, 1),
                          ),
                        ),
                        const SizedBox(height: AttaSpacing.m),
                      ],
                      if (dishIds.isNotEmpty || menus.isNotEmpty) ...[
                        Text(
                          'Votre commande :',
                          style: AttaTextStyle.subHeader.copyWith(color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: AttaSpacing.xxs),
                        ...dishIds.map((dishId) {
                          final quantity = reservation.dishIds[dishId]!;
                          final dish = restaurantService.getDishById(reservation.restaurantId, dishId);

                          if (dish == null) return const SizedBox.shrink();

                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${dish.name} x$quantity',
                                  overflow: TextOverflow.ellipsis,
                                  style: AttaTextStyle.content.copyWith(color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(width: AttaSpacing.xxs),
                              Text(
                                (dish.price * quantity).toEuro,
                                style: AttaTextStyle.label.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          );
                        }),
                        ...menus.map((m) {
                          final dishes = restaurantService.getDishesFromIds(
                            reservation.restaurantId,
                            m.selectedDishIds.toList(),
                          );
                          final menu = restaurantService.getMenuById(reservation.restaurantId, m.menuId);

                          if (dishes.isEmpty) return const SizedBox.shrink();

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: AttaSpacing.xxs),
                                    Text(
                                      menu?.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: AttaTextStyle.content.copyWith(color: Colors.grey.shade700),
                                    ),
                                    const SizedBox(height: AttaSpacing.xxs),
                                    ...dishes.map(
                                      (dish) => Text(
                                        dish.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: AttaTextStyle.content.copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                      ).withPadding(
                                          const EdgeInsets.only(left: AttaSpacing.m, bottom: AttaSpacing.xxs)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AttaSpacing.xs),
                              Text(
                                (menu?.price ?? 0).toEuro,
                                style: AttaTextStyle.label.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          );
                        }),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total :',
                              style: AttaTextStyle.subHeader.copyWith(color: Colors.grey.shade700),
                            ),
                            Text(
                              reservationService.calculateTotalAmount(reservation).toEuro,
                              style: AttaTextStyle.label.copyWith(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else ...[
              const SizedBox(width: AttaSpacing.m),
              Expanded(
                child: Text(
                  'Aucun commentaire ou commande',
                  style: AttaTextStyle.content.copyWith(color: Colors.grey.shade700),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

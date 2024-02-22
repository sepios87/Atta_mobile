part of '../user_reservations_page.dart';

class _ReservationFormulaDetail extends StatelessWidget {
  const _ReservationFormulaDetail(this.reservation, {this.withMenuDetail = true});

  final AttaReservation reservation;
  final bool withMenuDetail;

  @override
  Widget build(BuildContext context) {
    final dishIds = reservation.dishIds.keys;
    final menus = reservation.menus;

    return Column(
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
                      Text(
                        menu?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: AttaTextStyle.content.copyWith(color: Colors.grey.shade700),
                      ),
                      if (withMenuDetail) ...[
                        const SizedBox(height: AttaSpacing.xxs),
                        ...dishes.map(
                          (dish) => Text(
                            dish.name,
                            overflow: TextOverflow.ellipsis,
                            style: AttaTextStyle.content.copyWith(
                              color: Colors.grey.shade700,
                            ),
                          ).withPadding(
                            const EdgeInsets.only(left: AttaSpacing.m, bottom: AttaSpacing.xxs),
                          ),
                        ),
                      ],
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
    );
  }
}

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
                  child: ReservationFormulaDetail(reservation),
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

part of '../user_reservations_page.dart';

class _ReservationCardExpansion extends StatefulWidget {
  const _ReservationCardExpansion({
    required this.reservation,
    super.key,
  });

  final AttaReservation reservation;

  @override
  State<_ReservationCardExpansion> createState() => _ReservationCardExpansionState();
}

class _ReservationCardExpansionState extends State<_ReservationCardExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;
    final restaurant = restaurantService.restaurants.firstWhere((r) => r.id == reservation.restaurantId);

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTileTheme(
          minVerticalPadding: 0,
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            childrenPadding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
            onExpansionChanged: (isExpanded) {
              if (isExpanded) {
                context.read<UserReservationsCubit>().onExpandReservation(reservation);
              }
              setState(() => _isExpanded = isExpanded);
            },
            tilePadding: const EdgeInsets.only(right: AttaSpacing.m),
            trailing: Column(
              children: [
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.people_sharp,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: AttaSpacing.xxs),
                      Text(
                        reservation.numberOfPersons.toString(),
                        style: AttaTextStyle.label.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pour le forcer a sortir du continer sans overflow
                Transform.translate(
                  offset: const Offset(0, AttaSpacing.s),
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            title: _TitleReservationCardExpansion(
              reservation: reservation,
              restaurant: restaurant,
            ),
            children: [
              _ChildReservationTileExpansion(
                reservation: reservation,
                restaurant: restaurant,
              ),
              const SizedBox(height: AttaSpacing.m),
            ],
          ),
        ),
      ),
    );
  }
}

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AttaRadius.small),
            child: CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              width: 68,
              height: 68,
              maxWidthDiskCache: 1000,
              maxHeightDiskCache: 1000,
              useOldImageOnUrlChange: true,
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
                        pathParameters: RestaurantDetailPageArgument(
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
        ],
      ),
    );
  }
}

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
                  valueColor: AlwaysStoppedAnimation(AttaColors.primary),
                  strokeWidth: 2,
                ),
              ),
            ],
          );
        }

        final dishs = reservation.dishs ?? [];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 68,
              child: Column(
                children: [
                  if (reservation.tableId != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: AttaSpacing.xs),
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
                ],
              ),
            ),
            if ((reservation.comment != null && reservation.comment!.isNotEmpty) || dishs.isNotEmpty)
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
                      if (dishs.isNotEmpty) ...[
                        Text(
                          'Votre commande :',
                          style: AttaTextStyle.subHeader.copyWith(color: Colors.grey.shade800),
                        ),
                        const SizedBox(height: AttaSpacing.xxs),
                        ...dishs.map(
                          (dish) => Row(
                            children: [
                              Expanded(
                                child: Text(
                                  dish.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: AttaTextStyle.content.copyWith(color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(width: AttaSpacing.xxs),
                              Text(
                                dish.price.toEuro,
                                style: AttaTextStyle.label.copyWith(color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
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
                              dishs.fold<double>(0, (p, e) => p + e.price).toEuro,
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
              ),
          ],
        );
      },
    );
  }
}

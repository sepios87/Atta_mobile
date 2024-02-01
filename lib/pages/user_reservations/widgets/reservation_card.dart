part of '../user_reservations_page.dart';

class _ReservationCardExpansion extends StatefulWidget {
  const _ReservationCardExpansion(this.reservation);

  final AttaReservation reservation;

  @override
  State<_ReservationCardExpansion> createState() => _ReservationCardExpansionState();
}

class _ReservationCardExpansionState extends State<_ReservationCardExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final restaurant = restaurantService.restaurants.firstWhere((r) => r.id == widget.reservation.restaurantId);

    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          onExpansionChanged: (isExpanded) => setState(() => _isExpanded = isExpanded),
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
                      widget.reservation.numberOfPersons.toString(),
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
          title: Padding(
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
                    memCacheHeight: 68 * 2,
                    memCacheWidth: 68 * 2,
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
                      widget.reservation.dateTime.accurateFormat,
                      style: AttaTextStyle.label.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: AttaSpacing.xxs),
                    Text(
                      '#${widget.reservation.id}',
                      style: AttaTextStyle.caption.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: [
            Text('coucoucocucocuou'),
          ],
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

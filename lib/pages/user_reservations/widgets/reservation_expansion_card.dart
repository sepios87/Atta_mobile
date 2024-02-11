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

    return Dismissible(
      key: ValueKey(reservation.id),
      secondaryBackground: ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white).withPadding(
            const EdgeInsets.only(right: AttaSpacing.m),
          ),
        ),
      ),
      background: ColoredBox(
        color: AttaColors.black,
        child: Align(
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.edit, color: Colors.white).withPadding(
            const EdgeInsets.only(right: AttaSpacing.m),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final isConfirmed = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Annuler la réservation'),
                content: const Text('Êtes-vous sûr de vouloir supprimer cette réservation ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Confirmer'),
                  ),
                ],
              );
            },
          );

          if (isConfirmed != null && isConfirmed == true) {
            // ignore: use_build_context_synchronously
            await context.read<UserReservationsCubit>().onRemoveReservation(reservation);
          }
          return isConfirmed;
        } else if (direction == DismissDirection.startToEnd) {
          // context.adapativePushNamed(
          //   HomePage.routeName,
          // );
        }
        return false;
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTileTheme(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            child: BlocSelector<UserReservationsCubit, UserReservationsState, List<AttaReservation>>(
              selector: (state) => state.selectedReservations,
              builder: (context, selectedReservations) {
                final isOnSelectedState = selectedReservations.isNotEmpty;
                final isSelected = selectedReservations.contains(reservation);

                final backgroundColor = isSelected ? Colors.grey.withOpacity(0.1) : Colors.transparent;

                return InkWell(
                  onTap: isOnSelectedState
                      ? () => context.read<UserReservationsCubit>().onSelectedReservation(reservation)
                      : null,
                  onLongPress: isSelected
                      ? null
                      : () => context.read<UserReservationsCubit>().onSelectedReservation(reservation),
                  child: IgnorePointer(
                    ignoring: isOnSelectedState,
                    child: ExpansionTile(
                      backgroundColor: backgroundColor,
                      collapsedBackgroundColor: backgroundColor,
                      childrenPadding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
                      onExpansionChanged: (isExpanded) {
                        if (isExpanded) {
                          context.read<UserReservationsCubit>().onExpandReservation(reservation);
                        }
                        setState(() => _isExpanded = isExpanded);
                      },
                      tilePadding: const EdgeInsets.only(right: AttaSpacing.m),
                      leading: isSelected
                          ? Padding(
                              padding: const EdgeInsets.only(left: AttaSpacing.m),
                              child: Icon(Icons.check_rounded, color: AttaColors.black),
                            )
                          : null,
                      trailing: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AttaSpacing.xs,
                              vertical: AttaSpacing.xxxs,
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
                              duration: AttaAnimation.mediumAnimation,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

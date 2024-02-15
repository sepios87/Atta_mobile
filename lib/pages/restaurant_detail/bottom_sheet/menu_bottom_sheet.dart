part of '../restaurant_detail_page.dart';

Future<Wrapped<int?>?> _showMenuBottomSheet(
  BuildContext context, {
  required List<AttaMenuReservation> menusReservation,
}) async {
  return showModalBottomSheet<Wrapped<int?>?>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<RestaurantDetailCubit>(),
      child: _MenuBottomSheetContent(
        menusReservation: menusReservation,
      ),
    ),
  );
}

class _MenuBottomSheetContent extends StatelessWidget {
  const _MenuBottomSheetContent({
    required this.menusReservation,
  });

  final List<AttaMenuReservation> menusReservation;

  @override
  Widget build(BuildContext context) {
    final restaurantId = context.read<RestaurantDetailCubit>().state.restaurant.id;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: AttaSpacing.m,
            bottom: 48 + AttaSpacing.m,
          ),
          child: Column(
            children: [
              ...menusReservation.map((menuReservation) {
                final dishes = restaurantService.getDishesFromIds(
                  restaurantId,
                  menuReservation.selectedDishIds.toList(),
                );

                if (dishes.isEmpty) return const SizedBox.shrink();

                return Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(menuReservation.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m, vertical: AttaSpacing.s),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: dishes.map((dish) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AttaSpacing.xxs),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color: AttaColors.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: AttaSpacing.xs),
                                  Text(
                                    dish.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: AttaTextStyle.content,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Divider(height: 0, thickness: 1, color: Colors.grey.shade300),
                  ],
                );
              }),
              const SizedBox(height: AttaSpacing.l),
            ],
          ),
        ),
        Positioned(
          bottom: AttaSpacing.m,
          left: AttaSpacing.m,
          right: AttaSpacing.m,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(const Wrapped.value(null)),
            child: const Text('Ajouter un autre menu'),
          ),
        ),
      ],
    );
  }
}

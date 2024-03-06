part of '../restaurant_detail_page.dart';

Future<Wrapped<AttaMenuReservation?>?> _showMenuBottomSheet(
  BuildContext context, {
  required List<AttaMenuReservation> menusReservation,
  required int restaurantId,
}) async {
  return showModalBottomSheet<Wrapped<AttaMenuReservation?>?>(
    context: context,
    builder: (_) => _MenuBottomSheetContent(
      menusReservation: menusReservation,
      restaurantId: restaurantId,
    ),
  );
}

class _MenuBottomSheetContent extends StatelessWidget {
  const _MenuBottomSheetContent({
    required this.menusReservation,
    required this.restaurantId,
  });

  final List<AttaMenuReservation> menusReservation;
  final int restaurantId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 48 + AttaSpacing.m),
          child: Column(
            children: [
              const SizedBox(height: AttaSpacing.xxs),
              Center(
                child: Container(
                  height: 3,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                ),
              ),
              const SizedBox(height: AttaSpacing.m),
              ...menusReservation.map((menuReservation) {
                final dishes = restaurantService.getDishesFromIds(
                  restaurantId,
                  menuReservation.selectedDishIds.toList(),
                )..sort((a, b) => a.type.compareTo(b.type));

                if (dishes.isEmpty) return const SizedBox.shrink();

                return Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(Wrapped.value(menuReservation)),
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

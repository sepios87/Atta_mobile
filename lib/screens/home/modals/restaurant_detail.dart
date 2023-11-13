part of '../home_screen.dart';

class _RestaurantDetail extends StatelessWidget {
  const _RestaurantDetail(this.restaurant);

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      builder: (ctx, scollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AttaSpacing.xxs),
              Container(
                height: 2,
                width: 48,
                decoration: BoxDecoration(
                  color: AttaColors.black,
                  borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
                ),
              ),
              const SizedBox(height: AttaSpacing.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apercu de la carte',
                    style: AttaTextStyle.header.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border_rounded,
                      color: AttaColors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AttaSpacing.m),
              Expanded(
                child: ListView.separated(
                  controller: scollController,
                  itemCount: restaurant.dishes.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: AttaSpacing.xs),
                  itemBuilder: (ctx, index) {
                    return DishItemCard(restaurant.dishes[index]);
                  },
                ),
              ),
              const SizedBox(height: AttaSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Carte et précommande'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AttaColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AttaSpacing.s),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Réserver directement'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

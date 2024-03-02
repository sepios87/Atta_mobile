part of '../home_page.dart';

class _RestaurantDetailBottomSheet extends StatelessWidget {
  const _RestaurantDetailBottomSheet(this.restaurant);

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final mostDishs = restaurant.dishes.take(3).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
          child: BlocSelector<HomeCubit, HomeState, AttaUser?>(
            selector: (state) => state.user,
            builder: (context, user) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      restaurant.name,
                      overflow: TextOverflow.ellipsis,
                      style: AttaTextStyle.header.copyWith(fontSize: 22),
                    ),
                  ),
                  if (user != null)
                    FavoriteButton(
                      borderColor: AttaColors.black,
                      isFavorite: user.favoritesRestaurantIds.contains(restaurant.id),
                      onFavoriteChanged: () => context.read<HomeCubit>().onToogleFavoriteRestaurant(restaurant.id),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AttaSpacing.m),
        Text(
          'Apercu de la carte',
          style: AttaTextStyle.subHeader,
        ).withPadding(const EdgeInsets.symmetric(horizontal: AttaSpacing.m)),
        const SizedBox(height: AttaSpacing.xs),
        ...mostDishs.map(
          (d) => FormulaCard(
            formula: d,
            onTap: () {
              context
                  .adapativePushNamed<bool>(
                DishDetailPage.routeName,
                pathParameters: DishDetailPageArgument(
                  restaurantId: restaurant.id,
                  dishId: d.id,
                ).toPathParameters(),
              )
                  .then(
                (value) {
                  if (value != null && value) {
                    context
                      ..pop()
                      ..adapativePushNamed(
                        RestaurantDetailPage.routeName,
                        pathParameters: RestaurantDetailPageArgument(
                          restaurantId: restaurant.id,
                        ).toPathParameters(),
                      );
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: AttaSpacing.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context
                      ..pop()
                      ..adapativePushNamed(
                        RestaurantDetailPage.routeName,
                        pathParameters: RestaurantDetailPageArgument(
                          restaurantId: restaurant.id,
                        ).toPathParameters(),
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AttaColors.secondary,
                  ),
                  child: const Text(
                    'Voir le restaurant',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (userService.isLogged) ...[
                const SizedBox(width: AttaSpacing.s),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                      ..pop()
                      ..adapativePushNamed(
                        ReservationPage.routeName,
                        pathParameters: ReservationPageArgument(
                          restaurantId: restaurant.id,
                        ).toPathParameters(),
                      ),
                    child: const Text(
                      'Réserver directement',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AttaSpacing.m),
      ],
    );
  }
}

part of '../home_page.dart';

class _RestaurantPreviewBottomSheet extends StatelessWidget {
  const _RestaurantPreviewBottomSheet(this.restaurant);

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
          translate('home_page.restaurant_preview'),
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
                  child: Text(
                    translate('home_page.see_more_button'),
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
                    child: Text(
                      translate('home_page.reservation_button'),
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

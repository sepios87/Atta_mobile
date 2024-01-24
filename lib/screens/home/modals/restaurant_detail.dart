part of '../home_screen.dart';

class _RestaurantDetail extends StatelessWidget {
  const _RestaurantDetail(this.restaurant);

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.5,
      builder: (ctx, scollController) {
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AttaSpacing.xxs),
                Container(
                  height: 2,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AttaColors.black,
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                ),
                const SizedBox(height: AttaSpacing.m),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AttaSpacing.m,
                  ),
                  child: BlocSelector<HomeCubit, HomeState, AttaUser?>(
                    selector: (state) => state.user,
                    builder: (context, user) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Apercu de la carte',
                            style: AttaTextStyle.header.copyWith(
                              fontSize: 24,
                            ),
                          ),
                          if (user != null)
                            FavoriteButton(
                              isFavorite: user.favoritesRestaurantIds.contains(restaurant.id),
                              onFavoriteChanged: () => context.read<HomeCubit>().onSetFavoriteRestaurant(restaurant.id),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: AttaSpacing.m),
                Expanded(
                  child: ListView.builder(
                    controller: scollController,
                    padding: const EdgeInsets.only(bottom: 82),
                    itemCount: restaurant.dishs.length,
                    itemBuilder: (ctx, index) {
                      return FormulaCard(
                        formula: restaurant.dishs[index],
                        onTap: () {
                          context.adapativePushNamed(
                            DishDetailPage.routeName,
                            pathParameters: DishDetailScreenArgument(
                              restaurantId: restaurant.id,
                              dishId: restaurant.dishs[index].id,
                            ).toPathParameters(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AttaColors.white.withOpacity(0),
                      AttaColors.white.withOpacity(0.9),
                      AttaColors.white.withOpacity(1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.2, 1],
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: AttaSpacing.m,
                  right: AttaSpacing.m,
                  top: AttaSpacing.xl,
                  bottom: AttaSpacing.m,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                            ..pop()
                            ..adapativePushNamed(
                              RestaurantDetailPage.routeName,
                              pathParameters: RestaurantDetailScreenArgument(
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
                    const SizedBox(width: AttaSpacing.s),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context
                          ..pop()
                          ..adapativePushNamed(
                            ReservationPage.routeName,
                            pathParameters: ReservationScreenArgument(
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

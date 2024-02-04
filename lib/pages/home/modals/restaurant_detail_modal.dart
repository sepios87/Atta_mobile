part of '../home_page.dart';

class _RestaurantDetailModal extends StatelessWidget {
  const _RestaurantDetailModal(this.restaurant);

  final AttaRestaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.8,
      builder: (ctx, scollController) {
        return Stack(
          children: [
            Column(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AttaSpacing.m,
                  ),
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
                              isFavorite: user.favoritesRestaurantIds.contains(restaurant.id),
                              onFavoriteChanged: () =>
                                  context.read<HomeCubit>().onToogleFavoriteRestaurant(restaurant.id),
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
                Expanded(
                  child: ListView.builder(
                    controller: scollController,
                    padding: const EdgeInsets.only(bottom: 82),
                    itemCount: restaurant.dishes.length,
                    itemBuilder: (ctx, index) {
                      return FormulaCard(
                        formula: restaurant.dishes[index],
                        onTap: () {
                          context
                              .adapativePushNamed<bool>(
                            DishDetailPage.routeName,
                            pathParameters: DishDetailPageArgument(
                              restaurantId: restaurant.id,
                              dishId: restaurant.dishes[index].id,
                            ).toPathParameters(),
                          )
                              .then(
                            (value) {
                              if (value != null && value) {
                                context.adapativePushNamed(
                                  RestaurantDetailPage.routeName,
                                  pathParameters: RestaurantDetailPageArgument(
                                    restaurantId: restaurant.id,
                                  ).toPathParameters(),
                                );
                              }
                            },
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

part of '../home_page.dart';

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: AttaSpacing.m,
        top: AttaSpacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.mostRecentRestaurants),
            builder: (context, restaurants) {
              if (restaurants.isNotEmpty) {
                return _RestaurantList(
                  title: 'Les plus récents',
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.l),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.mostPopularRestaurants),
            builder: (context, restaurants) {
              if (restaurants.isNotEmpty) {
                return _RestaurantList(
                  title: 'Les plus populaires',
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.l),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.restaurants),
            builder: (context, restaurants) {
              final restaurantWithMostDishs = restaurants.withMostDishs(1).firstOrNull;

              if (restaurantWithMostDishs == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: AttaSpacing.m, bottom: AttaSpacing.l),
                child: RestaurantCard(
                  restaurant: restaurantWithMostDishs,
                  onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurantWithMostDishs),
                  positionedWidget: Positioned(
                    top: AttaSpacing.xxs,
                    left: AttaSpacing.xs,
                    child: Chip(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.s),
                      labelPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AttaRadius.small)),
                      color: MaterialStateProperty.all(AttaColors.primaryLight),
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        'Avec le plus de plats',
                        style: AttaTextStyle.caption.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.cheaperRestaurants),
            builder: (context, restaurants) {
              if (restaurants.isNotEmpty) {
                return _RestaurantList(
                  title: 'Les moins chers',
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.l),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.biggestNumberFormulaRestaurants),
            builder: (context, restaurants) {
              if (restaurants.isNotEmpty) {
                return _RestaurantList(
                  title: 'Avec le plus de choix',
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.l),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.restaurants),
            builder: (context, restaurants) {
              final restaurantWithMostDishs = restaurants.withCheaperMenu(1).firstOrNull;

              if (restaurantWithMostDishs == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: AttaSpacing.m, bottom: AttaSpacing.l),
                child: RestaurantCard(
                  restaurant: restaurantWithMostDishs,
                  onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurantWithMostDishs),
                  positionedWidget: Positioned(
                    top: AttaSpacing.xxs,
                    left: AttaSpacing.xs,
                    child: Chip(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.s),
                      labelPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AttaRadius.small)),
                      color: MaterialStateProperty.all(AttaColors.primaryLight),
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        'Avec le menu le moins cher',
                        style: AttaTextStyle.caption.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.otherRestaurants),
            builder: (context, restaurants) {
              if (restaurants.isNotEmpty) {
                return _RestaurantList(
                  title: 'Les hors catégories',
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.l),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

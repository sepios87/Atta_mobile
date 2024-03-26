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
                  title: translate('home_page.most_recent_restaurants'),
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.m),
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
                  title: translate('home_page.most_popular_restaurants'),
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.m),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.restaurants),
            builder: (context, restaurants) {
              final restaurantWithMostDishes = restaurants.withMostDishes(1).firstOrNull;

              if (restaurantWithMostDishes == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: AttaSpacing.m, bottom: AttaSpacing.l),
                child: RestaurantCard(
                  restaurant: restaurantWithMostDishes,
                  onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurantWithMostDishes),
                  positionedWidget: Positioned(
                    top: AttaSpacing.xxs,
                    left: AttaSpacing.xs,
                    child: Chip(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.s),
                      labelPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AttaRadius.small)),
                      color: MaterialStateProperty.all(AttaColors.primary),
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        translate('home_page.restaurant_with_most_dishes'),
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
                  title: translate('home_page.cheaper_restaurants'),
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.m),
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
                  title: translate('home_page.biggest_number_formula_restaurants'),
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.m),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
            selector: (state) => state.filterRestaurants(state.restaurants),
            builder: (context, restaurants) {
              final restaurantWithMostDishes = restaurants.withCheaperMenu(1).firstOrNull;

              if (restaurantWithMostDishes == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: AttaSpacing.m, bottom: AttaSpacing.l),
                child: RestaurantCard(
                  restaurant: restaurantWithMostDishes,
                  onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurantWithMostDishes),
                  positionedWidget: Positioned(
                    top: AttaSpacing.xxs,
                    left: AttaSpacing.xs,
                    child: Chip(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.s),
                      labelPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AttaRadius.small)),
                      color: MaterialStateProperty.all(AttaColors.primary),
                      visualDensity: VisualDensity.compact,
                      label: Text(
                        translate('home_page.restaurant_with_cheaper_menu'),
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
                  title: translate('home_page.other_restaurants'),
                  restaurants: restaurants,
                  margin: const EdgeInsets.only(bottom: AttaSpacing.m),
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

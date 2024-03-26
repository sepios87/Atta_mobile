part of '../home_page.dart';

class _SearchContent extends StatelessWidget {
  const _SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
      selector: (state) => state.filterRestaurants(state.searchRestaurants),
      builder: (context, restaurants) {
        if (restaurants.isEmpty) {
          return Center(child: Text(translate('home_page.no_restaurant_found')));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AttaSpacing.xxs),
          itemCount: restaurants.length,
          itemBuilder: (context, index) => _RestaurantSearchCard(restaurant: restaurants[index]),
        );
      },
    );
  }
}

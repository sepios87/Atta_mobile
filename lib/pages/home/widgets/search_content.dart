part of '../home_page.dart';

class _SearchContent extends StatelessWidget {
  const _SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
      selector: (state) => state.filteredSearchRestaurants,
      builder: (context, restaurants) {
        if (restaurants.isEmpty) {
          return const Center(
            child: Text('Aucun résultat'),
          );
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

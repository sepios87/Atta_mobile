part of '../home_page.dart';

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AttaSpacing.m,
          top: AttaSpacing.xs,
        ),
        child: BlocSelector<HomeCubit, HomeState, List<AttaRestaurant>>(
          selector: (state) => state.filteredRestaurants,
          builder: (context, restaurants) {
            return Column(
              children: [
                if (restaurants.isNotEmpty)
                  _RestaurantList(
                    title: 'Les plus populaires',
                    restaurants: restaurants,
                  ),
                const SizedBox(height: AttaSpacing.l),
                if (restaurants.isNotEmpty)
                  _RestaurantList(
                    title: 'Les plus populaires',
                    restaurants: restaurants,
                  ),
                const SizedBox(height: AttaSpacing.l),
                if (restaurants.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: AttaSpacing.m),
                    child: RestaurantCard(
                      restaurant: restaurants.first,
                      onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurants.first),
                      positionedWidget: Positioned(
                        top: AttaSpacing.xs,
                        left: AttaSpacing.xs,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AttaRadius.small),
                            color: AttaColors.primaryLight,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AttaSpacing.xs,
                            vertical: AttaSpacing.xxs,
                          ),
                          child: Text(
                            'Nouveauté',
                            style: AttaTextStyle.caption.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AttaSpacing.l),
                if (restaurants.isNotEmpty)
                  _RestaurantList(
                    title: 'Les plus hots',
                    restaurants: restaurants,
                  ),
                const SizedBox(height: AttaSpacing.l),
              ],
            );
          },
        ),
      ),
    );
  }
}

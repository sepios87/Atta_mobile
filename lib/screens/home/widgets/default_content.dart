part of '../home_screen.dart';

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
                _RestaurantList(
                  title: 'Les plus populaires',
                  restaurants: restaurants.map((restaurant) => _RestaurantCard(restaurant: restaurant)).toList(),
                ),
                const SizedBox(height: AttaSpacing.l),
                _RestaurantList(
                  title: 'Les plus populaires',
                  restaurants: restaurants.map((restaurant) => _RestaurantCard(restaurant: restaurant)).toList(),
                ),
                const SizedBox(height: AttaSpacing.l),
                if (restaurants.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: AttaSpacing.m),
                    child: _RestaurantCard(
                      restaurant: restaurants.first,
                      isFullWidth: true,
                      positionedWidget: Positioned(
                        top: AttaSpacing.xs,
                        left: AttaSpacing.xs,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
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
                const SizedBox(height: 1000),
              ],
            );
          },
        ),
      ),
    );
  }
}

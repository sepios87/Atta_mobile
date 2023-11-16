part of '../restaurant_detail_screen.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RestaurantDetailCubit, RestaurantDetailState, AttaRestaurant>(
      selector: (state) => state.restaurant,
      builder: (context, restaurant) {
        return SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusExt.top(AttaRadius.medium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AttaSpacing.m),
                Text(
                  restaurant.name,
                  style: AttaTextStyle.bigHeader.copyWith(
                    color: AttaColors.secondary,
                  ),
                ),
                const SizedBox(height: AttaSpacing.xs),
                Row(
                  children: [
                    if (restaurant.category.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.food_bank_outlined),
                          const SizedBox(width: AttaSpacing.xxs),
                          Text(restaurant.category.first.name),
                        ],
                      ),
                    const SizedBox(width: AttaSpacing.xs),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => launchUrlString(
                          'https://www.google.com/maps/search/?api=1&query=${restaurant.address}',
                        ),
                        icon: const Icon(Icons.location_on_outlined),
                        label: Text(
                          restaurant.address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => launchUrlString(restaurant.website),
                      icon: const Icon(CupertinoIcons.globe),
                    ),
                    IconButton(
                      onPressed: () => launchUrlString('tel:${restaurant.phone}'),
                      icon: const Icon(Icons.phone_outlined),
                    ),
                  ],
                ),
                const SizedBox(height: AttaSpacing.m),
                Text(restaurant.description),
                const SizedBox(height: AttaSpacing.m),
                const _SearchBar(),
                const SizedBox(height: AttaSpacing.m),
              ],
            ),
          ),
        );
      },
    );
  }
}

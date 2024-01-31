part of '../restaurant_detail_page.dart';

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
                    if (restaurant.filters.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.food_bank_outlined),
                          const SizedBox(width: AttaSpacing.xxs),
                          Text(restaurant.filters.first.name),
                          const SizedBox(width: AttaSpacing.xs),
                        ],
                      ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => launchUrlString(
                          'https://www.google.com/maps/search/?api=1&query=${restaurant.fullAddress}',
                        ),
                        icon: const Icon(Icons.location_on_outlined),
                        label: Text(
                          restaurant.fullAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (restaurant.website != null)
                      IconButton(
                        onPressed: () => launchUrlString(restaurant.website!),
                        icon: const Icon(CupertinoIcons.globe),
                      ),
                    IconButton(
                      onPressed: () => launchUrlString('tel:${restaurant.phone}'),
                      icon: const Icon(Icons.phone_outlined),
                    ),
                  ],
                ),
                if (restaurant.description != null) ...[
                  const SizedBox(height: AttaSpacing.m),
                  Text(restaurant.description!),
                ],
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

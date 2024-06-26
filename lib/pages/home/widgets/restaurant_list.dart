part of '../home_page.dart';

class _RestaurantList extends StatelessWidget {
  const _RestaurantList({
    required this.title,
    required this.restaurants,
    this.margin = EdgeInsets.zero,
  });

  final String title;
  final List<AttaRestaurant> restaurants;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AttaTextStyle.header),
          const SizedBox(height: AttaSpacing.m),
          SizedBox(
            height: 98 +
                AttaSpacing.xxs +
                AttaTextStyle.header.fontSize! +
                AttaSpacing.xxs +
                AttaTextStyle.content.fontSize!,
            child: ListView.separated(
              padding: const EdgeInsets.only(right: AttaSpacing.m),
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              itemBuilder: (context, index) => SizedBox(
                width: 128,
                child: RestaurantCard(
                  restaurant: restaurants[index],
                  onTap: () => context.read<HomeCubit>().onRestaurantSelected(restaurants[index]),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(width: AttaSpacing.l),
            ),
          ),
        ],
      ),
    );
  }
}

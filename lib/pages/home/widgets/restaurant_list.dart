part of '../home_page.dart';

class _RestaurantList extends StatelessWidget {
  const _RestaurantList({
    required this.title,
    required this.restaurants,
  });

  final String title;
  final List<_RestaurantCard> restaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AttaTextStyle.header),
        const SizedBox(height: AttaSpacing.m),
        SizedBox(
          height: 98 + AttaSpacing.xxs + 48,
          child: ListView.separated(
            padding: const EdgeInsets.only(right: AttaSpacing.m),
            scrollDirection: Axis.horizontal,
            itemCount: restaurants.length,
            itemBuilder: (context, index) => restaurants[index],
            separatorBuilder: (context, index) => const SizedBox(width: AttaSpacing.l),
          ),
        ),
      ],
    );
  }
}

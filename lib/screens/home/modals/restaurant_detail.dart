part of '../home_screen.dart';

class _RestaurantDetail extends StatelessWidget {
  const _RestaurantDetail();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.l),
      child: Column(
        children: [
          const SizedBox(height: AttaSpacing.xxs),
          Container(
            height: 2,
            width: 48,
            decoration: BoxDecoration(
              color: AttaColors.black,
              borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
            ),
          ),
          const SizedBox(height: AttaSpacing.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apercu de la carte',
                style: AttaTextStyle.header.copyWith(
                  fontSize: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: AttaColors.black,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

part of '../dish_detail_page.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.restaurantId,
  });

  final int restaurantId;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.adaptativePopNamed(
          RestaurantDetailPage.routeName,
          pathParameters: RestaurantDetailScreenArgument(restaurantId: restaurantId).toPathParameters(),
        ),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AttaColors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

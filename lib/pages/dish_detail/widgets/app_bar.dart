part of '../dish_detail_page.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        // TODO(florian): si nous sommes sur la version web et qu'on est sur la page réservation ou detail d'un resto avant, il faudrait rediriger vers la page de réservation a nouveau
        onPressed: () => context.adaptativePopNamed(HomePage.routeName),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      actions: [
        FavoriteButton(
          isFavorite: context.read<DishDetailCubit>().state.isFavorite,
          onFavoriteChanged: () => context.read<DishDetailCubit>().toggleFavorite(),
        ),
        const SizedBox(width: AttaSpacing.m),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

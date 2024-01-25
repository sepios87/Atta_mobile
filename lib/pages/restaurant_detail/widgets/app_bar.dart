part of '../restaurant_detail_page.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
      buildWhen: (state, previous) =>
          state.selectedDate != previous.selectedDate || state.selectedOpeningTime != previous.selectedOpeningTime,
      builder: (context, state) {
        return SliverAppBar(
          // Remove the bottom line artefact
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          expandedHeight: 280,
          pinned: true,
          leading: IconButton(
            onPressed: () => context.adaptativePopNamed(HomePage.routeName),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          actions: [
            if (userService.isLogged)
              FavoriteButton(
                isFavorite: state.isFavorite,
                onFavoriteChanged: () => context.read<RestaurantDetailCubit>().onToogleFavoriteRestaurant(),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: state.restaurant.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AttaColors.black.withOpacity(0.6),
                          AttaColors.black.withOpacity(0.1),
                          AttaColors.black.withOpacity(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            // 32 is height of SelectHourly widget
            preferredSize: const Size.fromHeight(kToolbarHeight + 32),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: AttaSpacing.m,
                right: AttaSpacing.m,
                bottom: AttaSpacing.m,
              ),
              decoration: BoxDecoration(
                color: AttaColors.white,
                borderRadius: BorderRadiusExt.top(AttaRadius.medium),
              ),
              child: SelectHourly(
                openingTimes: state.restaurant.openingHoursSlots,
                selectedDate: state.selectedDate,
                selectedOpeningTime: state.selectedOpeningTime,
                onDateChanged: (date) {
                  context.read<RestaurantDetailCubit>().selectDate(date);
                },
                onOpeningTimeChanged: (openingTime) {
                  context.read<RestaurantDetailCubit>().selectOpeningTime(openingTime);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

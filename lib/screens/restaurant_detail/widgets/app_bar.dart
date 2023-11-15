part of '../restaurant_detail_screen.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
      buildWhen: (state, previous) =>
          state.selectedDate != previous.selectedDate && state.selectedOpeningTime != previous.selectedOpeningTime,
      builder: (context, state) {
        return SliverAppBar(
          // Remove the bottom line artefact
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0,
              color: AttaColors.white,
            ),
          ),
          expandedHeight: 280,
          pinned: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              state.restaurant.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(82 + AttaSpacing.m),
            child: Padding(
              padding: const EdgeInsets.only(top: AttaSpacing.m),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: AttaSpacing.m,
                  right: AttaSpacing.m,
                  top: AttaSpacing.xxs,
                  bottom: AttaSpacing.m,
                ),
                decoration: BoxDecoration(
                  color: AttaColors.white,
                  borderRadius: BorderRadiusExt.top(AttaRadius.medium),
                ),
                child: SelectHourly(
                  openingTimes: state.restaurant.openingTimes,
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
          ),
        );
      },
    );
  }
}

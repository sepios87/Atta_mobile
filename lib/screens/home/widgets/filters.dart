part of '../home_screen.dart';

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AttaSpacing.m,
      ),
      scrollDirection: Axis.horizontal,
      child: BlocSelector<HomeCubit, HomeState, List<AttaFilter>>(
        selector: (state) => state.activeFilters,
        builder: (context, state) {
          return Row(
            children: AttaFilter.values.map((filter) {
              final isSelected = state.contains(filter);

              return Padding(
                padding: const EdgeInsets.only(
                  right: AttaSpacing.xs,
                ),
                child: AnimatedSwitcher(
                  duration: AttaAnimation.fastAnimation,
                  child: FilterChip(
                    key: ValueKey('${filter.name}-$isSelected'),
                    side: const BorderSide(color: Colors.white),
                    label: Text(filter.name),
                    shape: const StadiumBorder(),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: AttaSpacing.xxs,
                    ),
                    labelStyle: AttaTextStyle.caption.copyWith(
                      color: isSelected ? AttaColors.white : AttaColors.black,
                    ),
                    backgroundColor: isSelected ? AttaColors.black : AttaColors.white,
                    onSelected: (_) {
                      context.read<HomeCubit>().selectFilter(filter);
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

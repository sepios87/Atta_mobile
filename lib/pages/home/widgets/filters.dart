part of '../home_page.dart';

class _Filters extends StatelessWidget {
  const _Filters({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AttaSpacing.m,
      ),
      scrollDirection: Axis.horizontal,
      child: BlocSelector<HomeCubit, HomeState, List<AttaRestaurantFilter>>(
        selector: (state) => state.activeFilters,
        builder: (context, state) {
          return Row(
            children: AttaRestaurantFilter.values.map((filter) {
              final isSelected = state.contains(filter);

              return Padding(
                padding: const EdgeInsets.only(right: AttaSpacing.xs),
                child: AnimatedSwitcher(
                  duration: AttaAnimation.fastAnimation,
                  child: FilterChip(
                    key: ValueKey('${filter.name}-$isSelected'),
                    selected: isSelected,
                    label: Text(filter.translatedName),
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

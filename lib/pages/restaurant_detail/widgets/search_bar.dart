part of '../restaurant_detail_page.dart';

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final searchKey = GlobalKey();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AttaSearchBar(
          key: searchKey,
          onFocus: (isOnFocus) {
            if (isOnFocus) {
              Scrollable.ensureVisible(
                searchKey.currentContext ?? context,
                curve: Curves.easeInOut,
                alignment: 0.02,
                duration: const Duration(milliseconds: 300),
              );
            }
          },
          onSearch: (value) {
            context.read<RestaurantDetailCubit>().onSearchTextChange(value);
          },
        ),
        const SizedBox(height: AttaSpacing.xs),
        BlocSelector<RestaurantDetailCubit, RestaurantDetailState, AttaFormulaType?>(
          selector: (state) => state.selectedFormulaType,
          builder: (context, selectedFormulaType) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AttaFormulaType.values
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AttaSpacing.xs),
                      child: FilterChip(
                        selected: selectedFormulaType == e,
                        label: Text(e.name),
                        onSelected: (_) => context.read<RestaurantDetailCubit>().selectFormulaFilter(e),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

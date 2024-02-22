part of '../menu_detail_page.dart';

class _DishTypeList extends StatelessWidget {
  const _DishTypeList({
    required this.type,
    required this.dishes,
  });

  final DishType type;
  final List<AttaDish> dishes;

  @override
  Widget build(BuildContext context) {
    if (dishes.isEmpty) return const SizedBox.shrink();

    return BlocSelector<MenuDetailCubit, MenuDetailState, int>(
      selector: (state) => state.selectedDishIds[type] ?? 0,
      builder: (context, selectedDishId) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type.translatedName, style: AttaTextStyle.header).withPadding(
              const EdgeInsets.symmetric(horizontal: AttaSpacing.m),
            ),
            const SizedBox(height: AttaSpacing.xxxs),
            ...dishes.map(
              (dish) => FormulaCard(
                formula: dish,
                onTap: () => context.read<MenuDetailCubit>().selectDish(dish),
                leading: Radio<int>(
                  value: dish.id,
                  groupValue: selectedDishId,
                  onChanged: null,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(height: AttaSpacing.m),
          ],
        );
      },
    );
  }
}

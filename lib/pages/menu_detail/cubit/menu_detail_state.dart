part of 'menu_detail_cubit.dart';

@immutable
class MenuDetailState {
  const MenuDetailState._({
    required this.restaurant,
    required this.menu,
    required this.selectedDishIds,
  });

  factory MenuDetailState.initial({required AttaRestaurant restaurant, required AttaMenu menu}) {
    return MenuDetailState._(
      restaurant: restaurant,
      menu: menu,
      selectedDishIds: const {},
    );
  }

  final AttaRestaurant restaurant;
  final AttaMenu menu;

  final Map<DishType, int> selectedDishIds;

  List<AttaDish> get dishes => restaurant.dishes.where((dish) => menu.disheIds.contains(dish.id)).toList();

  MenuDetailState copyWith({
    Map<DishType, int>? selectedDishIds,
  }) {
    return MenuDetailState._(
      selectedDishIds: selectedDishIds ?? this.selectedDishIds,
      restaurant: restaurant,
      menu: menu,
    );
  }
}

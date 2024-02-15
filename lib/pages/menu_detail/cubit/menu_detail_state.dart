part of 'menu_detail_cubit.dart';

@immutable
class MenuDetailState {
  const MenuDetailState._({
    required this.restaurant,
    required this.menu,
    required this.selectedDishIds,
    required this.reservationMenu,
  });

  factory MenuDetailState.initial({
    required AttaRestaurant restaurant,
    required AttaMenu menu,
    AttaMenuReservation? reservationMenu,
  }) {
    return MenuDetailState._(
      restaurant: restaurant,
      menu: menu,
      selectedDishIds: const {},
      reservationMenu: reservationMenu,
    );
  }

  final AttaRestaurant restaurant;
  final AttaMenu menu;
  final AttaMenuReservation? reservationMenu;

  final Map<DishType, int> selectedDishIds;

  bool get isEditable => reservationMenu != null;
  List<AttaDish> get dishes => restaurant.dishes.where((dish) => menu.disheIds.contains(dish.id)).toList();

  MenuDetailState copyWith({
    Map<DishType, int>? selectedDishIds,
  }) {
    return MenuDetailState._(
      selectedDishIds: selectedDishIds ?? this.selectedDishIds,
      restaurant: restaurant,
      menu: menu,
      reservationMenu: reservationMenu,
    );
  }
}

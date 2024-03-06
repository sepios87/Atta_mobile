import 'package:atta/entities/dish.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'menu_detail_state.dart';

class MenuDetailCubit extends Cubit<MenuDetailState> {
  MenuDetailCubit({
    required int restaurantId,
    required int menuId,
    required AttaMenuReservation? reservationMenu,
  }) : super(
          MenuDetailState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            menu: restaurantService.getMenuById(restaurantId, menuId)!,
            reservationMenu: reservationMenu,
          ),
        ) {
    _init();
  }

  void _init() {
    if (state.reservationMenu == null) {
      // Select firsts dishes by default
      for (final type in DishType.values) {
        final dish = state.dishes.firstWhereOrNull((dish) => dish.type == type);
        if (dish != null) selectDish(dish);
      }
    } else {
      for (final dishId in state.reservationMenu!.selectedDishIds) {
        final dish = state.dishes.firstWhereOrNull((dish) => dish.id == dishId);
        if (dish != null) selectDish(dish);
      }
    }
  }

  void selectDish(AttaDish dish) {
    final selectedDishIds = Map<DishType, int>.from(state.selectedDishIds);
    selectedDishIds[dish.type] = dish.id;
    emit(state.copyWith(selectedDishIds: selectedDishIds));
  }

  void addMenuToReservation() {
    reservationService.addOrUpdateMenuToReservation(
      restaurantId: state.restaurant.id,
      menuId: state.menu.id,
      selectedDishIds: state.selectedDishIds.values.toSet(),
      menuReservation: state.reservationMenu,
    );
  }

  void removeMenuFromReservation() {
    if (state.reservationMenu != null) {
      reservationService.removeMenuFromReservation(
        restaurantId: state.restaurant.id,
        menu: state.reservationMenu!,
      );
    }
  }
}

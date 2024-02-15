import 'package:atta/entities/dish.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dish_detail_state.dart';

class DishDetailCubit extends Cubit<DishDetailState> {
  DishDetailCubit({
    required int restaurantId,
    required int dishId,
  }) : super(
          DishDetailState.initial(
            dish: restaurantService.getDishById(restaurantId, dishId)!,
            restaurantId: restaurantId,
            isFavorite: userService.user?.favoriteDishesIds.contains((dishId, restaurantId)) ?? false,
            reservation: reservationService.getReservation(restaurantId),
          ),
        );

  void changeQuantity(int quantity) {
    emit(state.copyWith(quantity: quantity));
  }

  void addOrUpdateDishToReservation() {
    reservationService.addOrUpdateDishToReservation(
      restaurantId: state.restaurantId,
      dishId: state.dish.id,
      quantity: state.quantity,
    );
  }

  void removeDishFromReservation() {
    reservationService.removeDishFromReservation(
      restaurantId: state.restaurantId,
      dishId: state.dish.id,
    );
  }

  Future<void> toggleFavorite() async {
    await userService.toggleFavoriteDish(
      restaurantId: state.restaurantId,
      dishId: state.dish.id,
    );
  }
}

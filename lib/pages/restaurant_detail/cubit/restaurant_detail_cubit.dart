import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restaurant_detail_state.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit({
    required int restaurantId,
  }) : super(
          RestaurantDetailState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            selectedDate: reservationService.selectedDate ?? DateTime.now(),
            selectedOpeningTime: reservationService.selectedTime,
            isFavorite: userService.user?.favoritesRestaurantIds.contains(restaurantId) ?? false,
          ),
        );

  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedOpeningTime: const Wrapped.value(null),
      ),
    );
    reservationService.setReservationTime(
      time: state.selectedOpeningTime,
      date: date,
    );
  }

  void selectOpeningTime(TimeOfDay time) {
    emit(state.copyWith(selectedOpeningTime: Wrapped.value(time)));
    reservationService.setReservationTime(
      time: time,
      date: state.selectedDate,
    );
  }

  void selectFormulaFilter(AttaFormulaType type) {
    if (state.selectedFormulaType == type) {
      emit(state.copyWith(selectedFormulaType: const Wrapped.value(null)));
    } else {
      emit(state.copyWith(selectedFormulaType: Wrapped.value(type)));
    }
  }

  void onSearchTextChange(String value) {
    emit(state.copyWith(searchValue: value));
  }

  Future<void> onToogleFavoriteRestaurant() async {
    await userService.toggleFavoriteRestaurant(state.restaurant.id);
  }
}

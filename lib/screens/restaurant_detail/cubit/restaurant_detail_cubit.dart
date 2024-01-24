import 'package:atta/entities/filter.dart';
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

  void selectFormulaFilter(AttaFormulaFilter filter) {
    if (state.selectedFormulaFilter == filter) {
      emit(state.copyWith(selectedFormulaFilter: const Wrapped.value(null)));
    } else {
      emit(state.copyWith(selectedFormulaFilter: Wrapped.value(filter)));
    }
  }

  void onSearchTextChange(String value) {
    emit(state.copyWith(searchValue: value));
  }
}

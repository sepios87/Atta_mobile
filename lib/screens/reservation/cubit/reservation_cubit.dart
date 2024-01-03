import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit({
    required String restaurantId,
  }) : super(
          ReservationState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            selectedDate: reservationService.selectedDate ?? DateTime.now(),
            selectedTime: reservationService.selectedTime,
          ),
        );

  void onTableSelected(String? tableId) {
    if (state.selectedTableId == tableId || tableId == null) {
      emit(state.copyWith(selectedTableId: const Wrapped.value(null)));
    } else {
      emit(state.copyWith(selectedTableId: Wrapped.value(tableId)));
    }
  }

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

  void onNumberOfPersonsChanged(int value) {
    emit(state.copyWith(numberOfPersons: value));
  }
}

import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/restaurant_plan.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_state.dart';

const mockTables = [
  AttaTable(id: '1', x: 1, y: 1, numberOfSeats: 2, width: 1, height: 1),
  AttaTable(id: '2', x: 3, y: 1, numberOfSeats: 5, width: 3, height: 1),
  AttaTable(id: '3', x: 1, y: 3, numberOfSeats: 2, width: 1, height: 1),
  AttaTable(id: '4', x: 3, y: 3, numberOfSeats: 6, width: 2, height: 5),
  AttaTable(id: '5', x: 6, y: 3, numberOfSeats: 2, width: 1, height: 1),
  AttaTable(id: '6', x: 8, y: 3, numberOfSeats: 2, width: 1, height: 1),
  AttaTable(id: '7', x: 1, y: 5, numberOfSeats: 2, width: 1, height: 5),
];

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit({
    required int restaurantId,
  }) : super(
          ReservationState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            selectedDate: reservationService.selectedDate ?? DateTime.now(),
            selectedTime: reservationService.selectedTime,
            reservation: reservationService.getReservation(restaurantId),
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
    reservationService.setReservationDateTime(
      restaurantId: state.restaurant.id,
      date: date,
      time: const Wrapped.value(null),
    );
  }

  void selectOpeningTime(TimeOfDay time) {
    if (state.selectedOpeningTime == time) {
      emit(state.copyWith(selectedOpeningTime: const Wrapped.value(null)));
      reservationService.setReservationDateTime(
        restaurantId: state.restaurant.id,
        time: const Wrapped.value(null),
      );
    } else {
      emit(state.copyWith(selectedOpeningTime: Wrapped.value(time)));
      reservationService.setReservationDateTime(
        restaurantId: state.restaurant.id,
        time: Wrapped.value(time),
      );
    }
  }

  void onNumberOfPersonsChanged(int value) {
    emit(state.copyWith(numberOfPersons: value));
    final selectedId = state.selectedTableId;
    if (selectedId != null && mockTables.firstWhere((e) => e.id == selectedId).numberOfSeats < value) {
      emit(state.copyWith(selectedTableId: const Wrapped.value(null)));
    }
  }
}

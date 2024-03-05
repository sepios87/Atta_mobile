import 'package:atta/entities/day.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/restaurant_plan.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/opening_time_ext.dart';
import 'package:atta/main.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_state.dart';

const mockPlan = AttaRestaurantPlan(
  id: 1,
  tables: [
    AttaTable(id: 1, x: 1, y: 1, numberOfSeats: 2, width: 1, height: 1),
    AttaTable(id: 2, x: 3, y: 1, numberOfSeats: 4, width: 3, height: 1),
    AttaTable(id: 3, x: 1, y: 3, numberOfSeats: 2, width: 1, height: 1),
    AttaTable(id: 4, x: 3, y: 3, numberOfSeats: 8, width: 2, height: 5),
    AttaTable(id: 5, x: 6, y: 3, numberOfSeats: 2, width: 1, height: 1),
    AttaTable(id: 6, x: 8, y: 3, numberOfSeats: 2, width: 1, height: 1),
    AttaTable(id: 7, x: 1, y: 5, numberOfSeats: 6, width: 1, height: 5),
    AttaTable(id: 8, x: 6, y: 6, numberOfSeats: 6, width: 3, height: 2),
  ],
  toilets: [
    AttaToilets(id: 1, x: 8, y: 9),
  ],
  kitchens: [
    AttaKitchen(id: 1, x: 9, y: 0),
  ],
  doors: [
    AttaDoor(id: 1, x: 4, y: 10, isVertical: false),
    AttaDoor(id: 1, x: 5, y: 10, isVertical: false),
  ],
);

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit({
    required int restaurantId,
  }) : super(
          ReservationState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            selectedDate: reservationService.selectedDate ?? DateTime.now(),
            selectedTime: reservationService.selectedTime,
            reservation: reservationService.getReservation(restaurantId) ??
                AttaReservation.fromRestaurantId(restaurantId: restaurantId),
          ),
        );

  void onTableSelected(int? tableId) {
    final reservationTableId = state.reservation.tableId;

    if (reservationTableId == tableId || tableId == null) {
      emit(state.copyWith(reservation: state.reservation.copyWith(tableId: const Wrapped.value(null))));
    } else {
      emit(state.copyWith(reservation: state.reservation.copyWith(tableId: Wrapped.value(tableId))));
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

  void selectFirstOpeningTime() {
    final openingTimes = state.restaurant.openingHoursSlots.getTimesOfDay(AttaDay.fromDateTime(state.selectedDate));
    if (openingTimes.isNotEmpty) {
      selectOpeningTime(openingTimes.first);
    }
  }

  void onNumberOfPersonsChanged(int value) {
    AttaReservation reservation = state.reservation.copyWith(numberOfPersons: value);
    final table = mockPlan.tables.firstWhereOrNull((e) => e.id == state.reservation.tableId);

    if (table != null && !state.isSelectableTable(table, value)) {
      reservation = reservation.copyWith(tableId: const Wrapped.value(null));
    }

    emit(state.copyWith(reservation: reservation));
  }

  Future<void> onSendReservation({required String comment}) async {
    emit(state.copyWith(status: ReservationLoadingStatus()));
    try {
      final reservation = state.reservation.copyWith(
        dateTime: DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
          state.selectedOpeningTime!.hour,
          state.selectedOpeningTime!.minute,
        ),
        comment: comment.isEmpty ? null : comment,
      );
      await reservationService.sendReservation(reservation);
      emit(state.copyWith(status: ReservationSuccessStatus()));
    } catch (e) {
      emit(state.copyWith(status: ReservationErrorStatus(e.toString())));
      emit(state.copyWith(status: ReservationIdleStatus()));
    }
  }

  void refreshReservation() {
    emit(
      state.copyWith(
        reservation: reservationService.getReservation(state.restaurant.id) ??
            AttaReservation.fromRestaurantId(restaurantId: state.restaurant.id),
      ),
    );
  }
}

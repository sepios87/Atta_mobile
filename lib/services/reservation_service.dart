import 'package:atta/entities/dish.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:flutter/material.dart';

class ReservationService {
  final _reservations = <int, AttaReservation>{};

  TimeOfDay? _selectedTime;
  DateTime _selectedDate = DateTime.now();

  TimeOfDay? get selectedTime => _selectedTime;
  DateTime? get selectedDate => _selectedDate;
  AttaReservation? getReservation(int restaurantId) => _reservations[restaurantId];

  void setReservationDateTime({
    required int restaurantId,
    Wrapped<TimeOfDay?>? time,
    DateTime? date,
  }) {
    if (date != null) _selectedDate = date;
    if (time != null) {
      if (time.value == null) {
        _selectedTime = null;
      } else {
        _selectedTime = time.value;
        final newDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        final currentReservation = _reservations[restaurantId];
        if (currentReservation != null) {
          _reservations[restaurantId] = currentReservation.copyWith(dateTime: newDateTime);
        } else {
          _reservations[restaurantId] = AttaReservation.fromDateTime(
            restaurantId: restaurantId,
            dateTime: newDateTime,
          );
        }
      }
    }
  }

  void addDishToReservation({
    required int restaurantId,
    required AttaDish dish,
    required int quantity,
  }) {
    final currentReservation = _reservations[restaurantId];
    if (currentReservation != null) {
      final newDishes = currentReservation.dishes ?? {};
      newDishes[dish] = quantity;
      _reservations[restaurantId] = currentReservation.copyWith(dishes: newDishes);
    } else {
      _reservations[restaurantId] = AttaReservation.fromDishes(
        restaurantId: restaurantId,
        dishes: {dish: quantity},
      );
    }
  }

  void removeDishFromReservation({
    required int restaurantId,
    required AttaDish dish,
  }) {
    final currentReservation = _reservations[restaurantId];
    if (currentReservation != null) {
      final newDishes = currentReservation.dishes ?? {}
        ..remove(dish);
      _reservations[restaurantId] = currentReservation.copyWith(dishes: newDishes);
    }
  }

  Future<Map<String, dynamic>> sendReservation(AttaReservation reservation) async {
    final data = await databaseService.createReservation(reservation);
    final newReservation = AttaReservation.fromMap(data).copyWith(dishes: reservation.dishes);
    userService.addOrUpdateReservation(newReservation);

    _reservations.remove(reservation.restaurantId);
    resetReservationDateTime();
    return data;
  }

  void resetReservationDateTime() {
    _selectedTime = null;
    _selectedDate = DateTime.now();
  }

  Future<void> removeReservation(int reservationId) async {
    await databaseService.removeReservation(reservationId);
    userService.removeReservation(reservationId);
  }

  Future<void> fetchReservationWithDishes(
    AttaReservation reservation,
  ) async {
    if (reservation.id == null) return;

    final dishes = await databaseService.getReservationDishes(reservation.id!);
    userService.addOrUpdateReservation(reservation.copyWith(dishes: dishes));
  }
}

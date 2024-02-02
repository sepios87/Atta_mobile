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
      final newDishs = currentReservation.dishs ?? {};
      newDishs[dish] = quantity;
      _reservations[restaurantId] = currentReservation.copyWith(dishs: newDishs);
    } else {
      _reservations[restaurantId] = AttaReservation.fromDishs(
        restaurantId: restaurantId,
        dishs: {dish: quantity},
      );
    }
  }

  void removeDishFromReservation({
    required int restaurantId,
    required AttaDish dish,
  }) {
    final currentReservation = _reservations[restaurantId];
    if (currentReservation != null) {
      final newDishs = currentReservation.dishs ?? {}
        ..remove(dish);
      _reservations[restaurantId] = currentReservation.copyWith(dishs: newDishs);
    }
  }

  Future<Map<String, dynamic>> sendReservation(AttaReservation reservation) async {
    final data = await databaseService.createReservation(reservation);
    userService.addReservation(AttaReservation.fromMap(data));
    return data;
  }

  void resetReservation() {
    _selectedTime = null;
    _selectedDate = DateTime.now();
  }

  Future<AttaReservation> fetchReservationWithDishs(
    AttaReservation reservation,
  ) async {
    if (reservation.id == null) return reservation;

    final dishs = await databaseService.getReservationDishs(reservation.id!);
    return reservation.copyWith(dishs: dishs);
  }
}

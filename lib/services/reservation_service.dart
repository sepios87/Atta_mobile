import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:flutter/material.dart';

class ReservationService {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  TimeOfDay? get selectedTime => _selectedTime;
  DateTime? get selectedDate => _selectedDate;

  void setReservationDateTime({
    Wrapped<TimeOfDay?>? time,
    DateTime? date,
  }) {
    if (time != null) _selectedTime = time.value;
    if (date != null) _selectedDate = date;
  }

  void sendReservation(
    String restaurantId,
    String? tableId,
    int numberOfPersons,
    List<String> formulaIds,
    String comment,
  ) {
    // TODO(florian): implement
    print('Reservation sent at $_selectedTime on $_selectedDate');
  }

  void resetReservation() {
    _selectedTime = null;
    _selectedDate = null;
  }

  Future<AttaReservation> fetchReservationWithDishs(
    AttaReservation reservation,
  ) async {
    final dishs = await databaseService.getReservationDishs(reservation.id);
    return reservation.copyWith(dishs: dishs);
  }
}

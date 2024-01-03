import 'package:flutter/material.dart';

class ReservationService {
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  TimeOfDay? get selectedTime => _selectedTime;
  DateTime? get selectedDate => _selectedDate;

  void setReservationTime({
    required TimeOfDay? time,
    required DateTime date,
  }) {
    _selectedTime = time;
    _selectedDate = date;
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
}

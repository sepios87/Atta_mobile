import 'package:flutter/material.dart';

class AttaReservation {
  AttaReservation({
    required this.id,
    required this.userId,
    required this.time,
    required this.date,
    required this.restaurantId,
    required this.tableId,
    required this.numberOfPersons,
    required this.formulaIds,
    required this.comment,
  });

  final String id;
  final String userId;
  final TimeOfDay time;
  final DateTime date;
  final String restaurantId;
  final String? tableId;
  final int numberOfPersons;
  final List<String> formulaIds;
  final String comment;
}

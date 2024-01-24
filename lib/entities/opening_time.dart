import 'package:flutter/material.dart';

class AttaOpeningHoursSlots {
  const AttaOpeningHoursSlots({
    required this.open,
    required this.close,
  });

  final TimeOfDay open;
  final TimeOfDay close;
}

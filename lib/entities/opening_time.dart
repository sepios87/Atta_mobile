import 'package:flutter/material.dart';

class AttaOpeningTime {
  const AttaOpeningTime({
    required this.open,
    required this.close,
  });

  final TimeOfDay open;
  final TimeOfDay close;
}

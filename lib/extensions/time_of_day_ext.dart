import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  /// Converts [TimeOfDay] to [DateTime] with today's date.
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  int get inMinutes => hour * 60 + minute;
}

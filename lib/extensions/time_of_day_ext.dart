import 'package:flutter/material.dart';

extension TimeOfDayExt on TimeOfDay {
  /// Converts [TimeOfDay] to [DateTime] with today's date.
  String toHHmm() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay fromHHmm(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  int get inMinutes => hour * 60 + minute;
}

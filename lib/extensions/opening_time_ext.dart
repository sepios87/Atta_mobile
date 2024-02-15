import 'package:atta/entities/day.dart';
import 'package:atta/entities/opening_hours_slots.dart';
import 'package:atta/extensions/time_of_day_ext.dart';
import 'package:flutter/material.dart';

extension MapOpeningTimeExtension on Map<AttaDay, List<AttaOpeningHoursSlots>> {
  Set<TimeOfDay> getTimesOfDay(AttaDay day) {
    if (!containsKey(day)) return {};
    final times = <TimeOfDay>[];

    for (final openingTime in this[day]!) {
      TimeOfDay tempOpeningTime = openingTime.openingTime;
      while (tempOpeningTime.inMinutes < openingTime.closingTime.inMinutes) {
        times.add(tempOpeningTime);
        tempOpeningTime = TimeOfDay(
          hour: tempOpeningTime.minute >= 30 ? tempOpeningTime.hour + 1 : tempOpeningTime.hour,
          minute: tempOpeningTime.minute >= 30 ? 0 : 30,
        );
      }
      times.add(openingTime.closingTime);
    }

    times.sort((a, b) {
      if (a.hour == b.hour) return a.minute.compareTo(b.minute);
      return a.hour.compareTo(b.hour);
    });

    return Set.from(times);
  }
}

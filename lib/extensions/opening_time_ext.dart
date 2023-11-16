import 'package:atta/entities/day.dart';
import 'package:atta/entities/opening_time.dart';
import 'package:flutter/material.dart';

extension MapOpeningTimeExtension on Map<AttaDay, List<AttaOpeningTime>> {
  Set<TimeOfDay> getTimesOfDay(AttaDay day) {
    if (!containsKey(day)) return {};
    final times = <TimeOfDay>[];
    for (final openingTime in this[day]!) {
      // TODO(florian): refacto and update for 30min diff
      TimeOfDay tempOpeningTime = openingTime.open;
      while (tempOpeningTime.hour < openingTime.close.hour) {
        times.add(tempOpeningTime);
        tempOpeningTime = TimeOfDay(
          hour: tempOpeningTime.hour + 1,
          minute: tempOpeningTime.minute,
        );
      }
      times.add(openingTime.close);
    }

    times.sort((a, b) => a.hour > b.hour ? 1 : -1);

    return Set.from(times);
  }
}

import 'package:atta/extensions/time_of_day_ext.dart';
import 'package:flutter/material.dart';

class AttaOpeningHoursSlots {
  const AttaOpeningHoursSlots({
    required this.openingTime,
    required this.closingTime,
  });

  factory AttaOpeningHoursSlots.fromMap(Map<String, dynamic> map) {
    return AttaOpeningHoursSlots(
      openingTime: TimeOfDayExt.fromHHmm(map['open'].toString()),
      closingTime: TimeOfDayExt.fromHHmm(map['close'].toString()),
    );
  }

  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  Map<String, dynamic> toMap() {
    return {
      'open': openingTime.toHHmm(),
      'close': closingTime.toHHmm(),
    };
  }
}

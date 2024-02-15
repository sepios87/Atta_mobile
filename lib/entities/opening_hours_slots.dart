import 'package:atta/extensions/time_of_day_ext.dart';
import 'package:flutter/material.dart';

class AttaOpeningHoursSlots {
  const AttaOpeningHoursSlots({
    required this.openingTime,
    required this.closingTime,
  });

  factory AttaOpeningHoursSlots.fromMap(Map<String, dynamic> map) {
    return AttaOpeningHoursSlots(
      openingTime: TimeOfDay.fromDateTime(DateTime.tryParse(map['open'].toString()) ?? DateTime.now()),
      closingTime: TimeOfDay.fromDateTime(DateTime.tryParse(map['close'].toString()) ?? DateTime.now()),
    );
  }

  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  Map<String, dynamic> toMap() {
    return {
      'open': openingTime.toDateTime(),
      'close': closingTime.toDateTime(),
    };
  }
}

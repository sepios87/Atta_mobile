import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return day == tomorrow.day && month == tomorrow.month && year == tomorrow.year;
  }

  String get format {
    if (isToday) {
      return "Aujourd'hui";
    } else if (isTomorrow) {
      return 'Demain';
    } else {
      return DateFormat('dd/MM').format(this);
    }
  }
}

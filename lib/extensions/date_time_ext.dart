import 'package:atta/extensions/string_ext.dart';
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

  String format() {
    if (isToday) {
      return "Aujourd'hui";
    } else if (isTomorrow) {
      return 'Demain';
    }
    return DateFormat('dd/MM').format(this);
  }

  String accurateFormat({bool withPronoun = false}) {
    if (isToday) {
      return "Aujourd'hui à ${DateFormat('HH:mm').format(this)}";
    } else if (isTomorrow) {
      return 'Demain à ${DateFormat('HH:mm').format(this)}';
    }
    return '${withPronoun ? 'Le' : ''} ${DateFormat('EEEE dd/MM à HH:mm').format(this).capitalize()}';
  }
}

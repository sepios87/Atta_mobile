import 'package:flutter_translate/flutter_translate.dart';
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
      return translate('date_time.today');
    } else if (isTomorrow) {
      return translate('date_time.tomorrow');
    }
    return DateFormat('dd/MM').format(this);
  }

  String accurateFormat({bool withPronoun = false}) {
    if (isToday) {
      return translate('date_time.today_at', args: {'time': DateFormat('HH:mm').format(this)});
    } else if (isTomorrow) {
      return translate('date_time.tomorrow_at', args: {'time': DateFormat('HH:mm').format(this)});
    }
    if (withPronoun) {
      return translate(
        'date_time.at',
        args: {'date': DateFormat('dd/MM').format(this), 'time': DateFormat('HH:mm').format(this)},
      );
    }
    return DateFormat('dd/MM - HH:mm').format(this);
  }
}

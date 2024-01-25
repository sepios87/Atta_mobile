enum AttaDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  factory AttaDay.fromDateTime(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return AttaDay.monday;
      case DateTime.tuesday:
        return AttaDay.tuesday;
      case DateTime.wednesday:
        return AttaDay.wednesday;
      case DateTime.thursday:
        return AttaDay.thursday;
      case DateTime.friday:
        return AttaDay.friday;
      case DateTime.saturday:
        return AttaDay.saturday;
      case DateTime.sunday:
        return AttaDay.sunday;
      default:
        throw Exception('Invalid DateTime');
    }
  }

  factory AttaDay.fromValue(int value) => AttaDay.values[value];
}

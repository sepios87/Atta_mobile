class AttaReservation {
  AttaReservation({
    required this.id,
    required this.userId,
    required this.dateTime,
    required this.restaurantId,
    required this.tableId,
    required this.numberOfPersons,
    required this.dishIds,
    required this.comment,
  });

  final int id;
  final String userId;
  final DateTime dateTime;
  final String restaurantId;
  final String? tableId;
  final int numberOfPersons;
  final List<String> dishIds;
  final String comment;
}

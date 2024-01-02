class AttaRestaurantPlan {
  const AttaRestaurantPlan({
    required this.id,
    required this.tables,
  });

  final String id;
  final List<AttaTable> tables;
}

class AttaTable {
  const AttaTable({
    required this.id,
    required this.x,
    required this.y,
    required this.numberOfSeats,
    required this.width,
    required this.height,
  });

  final String id;
  final int x;
  final int y;
  final int numberOfSeats;
  final int width;
  final int height;
}

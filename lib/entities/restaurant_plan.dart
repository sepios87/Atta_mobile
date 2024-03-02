class AttaRestaurantPlan {
  const AttaRestaurantPlan({
    required this.id,
    required this.tables,
  });

  final String id;
  final List<AttaTable> tables;
}

class PositionnedElement {
  const PositionnedElement({
    required this.id,
    required this.x,
    required this.y,
  });

  final int id;
  final double x;
  final double y;
}

class Toilets extends PositionnedElement {
  Toilets({required super.id, required super.x, required super.y});
}

class Kitchen extends PositionnedElement {
  Kitchen({required super.id, required super.x, required super.y});
}

class Door extends PositionnedElement {
  Door({required super.id, required super.x, required super.y});
}

class AttaTable extends PositionnedElement {
  const AttaTable({
    required super.id,
    required super.x,
    required super.y,
    required this.numberOfSeats,
    required this.width,
    required this.height,
  });

  final int numberOfSeats;
  final int width;
  final int height;
}

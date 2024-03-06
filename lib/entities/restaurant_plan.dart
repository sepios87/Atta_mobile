class AttaRestaurantPlan {
  const AttaRestaurantPlan({
    required this.id,
    required this.tables,
    required this.toilets,
    required this.kitchens,
    required this.doors,
  });

  final int id;
  final List<AttaTable> tables;
  final List<AttaToilets> toilets;
  final List<AttaKitchen> kitchens;
  final List<AttaDoor> doors;

  List<AttaPositionnedElement> get positionedElements => [
        ...tables,
        ...toilets,
        ...kitchens,
        ...doors,
      ];
}

class AttaToilets extends AttaPositionnedElement {
  const AttaToilets({required super.id, required super.x, required super.y});
}

class AttaKitchen extends AttaPositionnedElement {
  const AttaKitchen({required super.id, required super.x, required super.y});
}

class AttaDoor extends AttaPositionnedElement {
  const AttaDoor({
    required super.id,
    required super.x,
    required super.y,
    required this.isVertical,
  });

  final bool isVertical;
}

class AttaTable extends AttaPositionnedElement {
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

sealed class AttaPositionnedElement {
  const AttaPositionnedElement({
    required this.id,
    required this.x,
    required this.y,
  });

  final int id;
  final double x;
  final double y;
}

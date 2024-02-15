abstract class AttaFormula {
  AttaFormula({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  final int id;
  final String name;
  final String imageUrl;
  final String? description;
  final num price;
}

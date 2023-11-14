class AttaMenu {
  AttaMenu({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.dishIds,
  });

  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final List<String> dishIds;
}

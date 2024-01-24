import 'package:atta/entities/formula.dart';

class AttaDish extends AttaFormula {
  AttaDish({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.ingredients,
  });

  final String ingredients;
}

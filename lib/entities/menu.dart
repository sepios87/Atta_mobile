import 'package:atta/entities/formula.dart';

class AttaMenu extends AttaFormula {
  AttaMenu({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.dishIds,
  });

  final List<String> dishIds;
}

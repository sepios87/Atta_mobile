import 'package:atta/entities/formula.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaDish extends AttaFormula {
  AttaDish({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.ingredients,
  });

  factory AttaDish.fromMap(Map<String, dynamic> map) {
    return AttaDish(
      id: map.parse<int>('id'),
      name: map.parse<String>('name', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      description: map.parse<String?>('description'),
      price: map.parse<num>('price'),
      ingredients: map.parse<String>('ingredients', fallback: ''),
    );
  }

  final String ingredients;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'price': price,
      'ingredients': ingredients,
    };
  }

  AttaDish copy() => AttaDish.fromMap(toMap());

  @override
  String toString() => toMap().toString();
}

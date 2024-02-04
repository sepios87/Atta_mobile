import 'package:atta/entities/dish.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaMenu extends AttaFormula {
  AttaMenu._({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.dishes,
  });

  factory AttaMenu.fromMap(Map<String, dynamic> map) {
    return AttaMenu._(
      id: map.parse<int>('id'),
      name: map.parse<String>('name', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      description: map.parse<String?>('description'),
      price: map.parse<num>('price'),
      dishes: map.parse<List>('dishes', fallback: []).map((e) => AttaDish.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  final List<AttaDish> dishes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'price': price,
      'dishes': dishes.map((e) => e.toMap()).toList(),
    };
  }

  AttaMenu copy() => AttaMenu.fromMap(toMap());

  @override
  String toString() => toMap().toString();
}

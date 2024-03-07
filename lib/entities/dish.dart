import 'package:atta/entities/formula.dart';
import 'package:atta/extensions/map_ext.dart';
import 'package:flutter_translate/flutter_translate.dart';

enum DishType {
  entrance,
  main,
  accompaniment,
  dessert,
  drink;

  factory DishType.fromValue(dynamic value) {
    return DishType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DishType.main,
    );
  }

  String get translatedName {
    return switch (this) {
      DishType.entrance => translate('dish_type_entity.entrance'),
      DishType.main => translate('dish_type_entity.main'),
      DishType.accompaniment => translate('dish_type_entity.accompaniment'),
      DishType.dessert => translate('dish_type_entity.dessert'),
      DishType.drink => translate('dish_type_entity.drink'),
    };
  }

  int compareTo(DishType other) {
    return index.compareTo(other.index);
  }
}

class AttaDish extends AttaFormula {
  AttaDish._({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.ingredients,
    required this.type,
  });

  factory AttaDish.fromMap(Map<String, dynamic> map) {
    return AttaDish._(
      id: map.parse<int>('id'),
      name: map.parse<String>('name', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      description: map.parse<String?>('description'),
      price: map.parse<num>('price'),
      ingredients: map.parse<String>('ingredients', fallback: ''),
      type: DishType.fromValue(map['type']),
    );
  }

  final String ingredients;
  final DishType type;

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

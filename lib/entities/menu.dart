import 'package:atta/entities/formula.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaMenu extends AttaFormula {
  AttaMenu._({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.description,
    required super.price,
    required this.disheIds,
  });

  factory AttaMenu.fromMap(Map<String, dynamic> map) {
    return AttaMenu._(
      id: map.parse<int>('id'),
      name: map.parse<String>('name', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      description: map.parse<String?>('description'),
      price: map.parse<num>('price'),
      disheIds: map.parse<List>('disheIds', fallback: []).map((e) => int.parse((e as Map)['id'].toString())).toList(),
    );
  }

  final List<int> disheIds;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'description': description,
      'price': price,
      'disheIds': disheIds,
    };
  }

  AttaMenu copy() => AttaMenu.fromMap(toMap());

  @override
  String toString() => toMap().toString();
}

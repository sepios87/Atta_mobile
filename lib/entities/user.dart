import 'dart:convert';
import 'package:atta/extensions/map_ext.dart';

class AttaUser {
  AttaUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.imageUrl,
    this.favoritesRestaurantsId = const {},
    this.favoritesDishesId = const {},
    this.favoritesMenusId = const {},
  });

  factory AttaUser.fromMap(Map<String, dynamic> map) {
    return AttaUser(
      id: map.parse<String>('id'),
      firstName: map.parse<String?>('first_name'),
      lastName: map.parse<String?>('last_name'),
      phone: map.parse<String?>('phone'),
      imageUrl: map.parse<String?>('image_url'),
      // favoritesRestaurantsId: map.parse<List>('favoritesRestaurantsId', fallback: []).map((e) => e.toString()).toSet(),
      // favoritesDishesId: map.parse<List>('favoritesDishesId', fallback: []).map((e) => e.toString()).toSet(),
      // favoritesMenusId: map.parse<List>('favoritesMenusId', fallback: []).map((e) => e.toString()).toSet(),
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? imageUrl;
  final Set<String> favoritesRestaurantsId;
  final Set<String> favoritesDishesId;
  final Set<String> favoritesMenusId;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'image_url': imageUrl,
      // 'favoritesRestaurantsId': favoritesRestaurantsId.toList(),
      // 'favoritesDishesId': favoritesDishesId.toList(),
      // 'favoritesMenusId': favoritesMenusId.toList(),
    };
  }

  AttaUser copy() => AttaUser.fromMap(toMap());

  @override
  String toString() => jsonEncode(toMap());
}

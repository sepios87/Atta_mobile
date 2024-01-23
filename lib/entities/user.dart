import 'dart:convert';
import 'package:atta/extensions/map_ext.dart';

class AttaUser {
  AttaUser({
    required this.uid,
    this.firstName,
    this.lastName,
    this.phone,
    this.imageUrl,
    this.favoritesRestaurantsId = const {},
    this.favoritesDishesId = const {},
    this.favoritesMenusId = const {},
  });

  factory AttaUser.fromMap(String id, Map<String, dynamic> map) {
    return AttaUser(
      uid: id,
      firstName: map.parse<String?>('firstName'),
      lastName: map.parse<String?>('lastName'),
      phone: map.parse<String?>('phone'),
      imageUrl: map.parse<String?>('imageUrl'),
      favoritesRestaurantsId: map.parse<List>('favoritesRestaurantsId', fallback: []).map((e) => e.toString()).toSet(),
      favoritesDishesId: map.parse<List>('favoritesDishesId', fallback: []).map((e) => e.toString()).toSet(),
      favoritesMenusId: map.parse<List>('favoritesMenusId', fallback: []).map((e) => e.toString()).toSet(),
    );
  }

  final String uid;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? imageUrl;
  final Set<String> favoritesRestaurantsId;
  final Set<String> favoritesDishesId;
  final Set<String> favoritesMenusId;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'imageUrl': imageUrl,
      'favoritesRestaurantsId': favoritesRestaurantsId.toList(),
      'favoritesDishesId': favoritesDishesId.toList(),
      'favoritesMenusId': favoritesMenusId.toList(),
    };
  }

  AttaUser copy() => AttaUser.fromMap(uid, toMap());

  @override
  String toString() => jsonEncode(toMap());
}

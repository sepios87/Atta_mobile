import 'package:atta/extensions/map_ext.dart';

class AttaUser {
  AttaUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.imageUrl,
    this.favoritesRestaurantIds = const {},
  });

  factory AttaUser.fromMap(Map<String, dynamic> map, String? email) {
    return AttaUser(
      id: map.parse<String>('id'),
      firstName: map.parse<String?>('first_name'),
      lastName: map.parse<String?>('last_name'),
      phone: map.parse<String?>('phone'),
      email: email,
      imageUrl: map.parse<String?>('image_url'),
      favoritesRestaurantIds: map.parse<List>('favoritesRestaurantIds', fallback: []).map((e) {
        if (e is int) return e;
        return (e as Map<String, dynamic>).parse<int>('id');
      }).toSet(),
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? imageUrl;
  final Set<int> favoritesRestaurantIds;

  Map<String, dynamic> toMap() {
    final bdbMap = toMapForDb();
    bdbMap['favoritesRestaurantIds'] = favoritesRestaurantIds.toList();
    return bdbMap;
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'image_url': imageUrl,
    };
  }

  AttaUser copy() => AttaUser.fromMap(toMap(), email);

  @override
  String toString() => toMap().toString();
}

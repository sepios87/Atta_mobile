import 'package:atta/entities/reservation.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaUser {
  AttaUser._({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.imageUrl,
    required this.favoritesRestaurantIds,
    required this.reservations,
  });

  factory AttaUser.fromMinimalData({
    required String id,
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
  }) {
    return AttaUser._(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phone: null,
      email: email,
      imageUrl: imageUrl,
      favoritesRestaurantIds: {},
      reservations: [],
    );
  }

  factory AttaUser.fromMap(Map<String, dynamic> map, String? email) {
    return AttaUser._(
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
      reservations: map
          .parse<List>('reservations', fallback: [])
          .map((e) => AttaReservation.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? imageUrl;
  final Set<int> favoritesRestaurantIds;
  final List<AttaReservation> reservations;

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

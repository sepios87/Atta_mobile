import 'dart:collection';

import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/wrapped.dart';
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
    required this.favoriteDishesIds,
    required Iterable<AttaReservation> reservations,
    required this.languageCode,
  }) : reservations = SplayTreeSet.from(reservations, (a, b) {
          final compare = a.dateTime.compareTo(b.dateTime);
          // Si les dates sont égales, ca supprime la réservation car considérée comme doublon
          // TODO(florian): a voir si un SplayTreeSet est toujours necessaire
          if (compare != 0) return compare;
          return (a.id ?? 0).compareTo(b.id ?? 1);
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
      favoriteDishesIds: {},
      reservations: SplayTreeSet(),
      languageCode: null,
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
      favoriteDishesIds: map.parse<List>('favoritesDishes', fallback: []).map((e) {
        final map = e as Map<String, dynamic>;
        return (map.parse<int>('dish_id'), map.parse<int>('restaurant_id'));
      }).toSet(),
      reservations: map.parse<List>('reservations', fallback: []).map(
        (e) => AttaReservation.fromMap(e as Map<String, dynamic>),
      ),
      languageCode: map.parse<String?>('language_code'),
    );
  }

  final String id;
  final String? firstName;
  final String? lastName;
  // TODO(florian): phone est dispo dans le user par defaut de supabase, le supp de l'attribut phone dans la table user de la bdd ?
  final String? phone;
  final String? email;
  final String? imageUrl;
  final Set<int> favoritesRestaurantIds;
  final Set<(int dishId, int restaurantId)> favoriteDishesIds;
  final SplayTreeSet<AttaReservation> reservations;
  final String? languageCode;

  String get fullName =>
      '${lastName?.toUpperCase().replaceAll(' ', ' ') ?? ''} ${firstName?.replaceAll(' ', '') ?? ''}'.trim();

  Map<String, dynamic> toMap() {
    final bdbMap = toMapForDb();
    bdbMap['favoritesRestaurantIds'] = favoritesRestaurantIds.toList();
    bdbMap['reservations'] = reservations.map((e) => e.toString()).toList();
    return bdbMap;
  }

  Map<String, dynamic> toMapForDb() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'image_url': imageUrl,
      'language_code': languageCode,
    };
  }

  AttaUser copyWith({
    Set<AttaReservation>? reservations,
    Wrapped<String?>? firstName,
    Wrapped<String?>? lastName,
    Wrapped<String?>? phone,
    Wrapped<String?>? imageUrl,
    String? languageCode,
  }) {
    return AttaUser._(
      id: id,
      firstName: firstName == null ? this.firstName : firstName.value,
      lastName: lastName == null ? this.lastName : lastName.value,
      phone: phone == null ? this.phone : phone.value,
      email: email,
      imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
      favoritesRestaurantIds: favoritesRestaurantIds,
      favoriteDishesIds: favoriteDishesIds,
      reservations: reservations ?? this.reservations,
      languageCode: languageCode,
    );
  }

  @override
  String toString() => toMap().toString();
}

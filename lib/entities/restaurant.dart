import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_hours_slots.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaRestaurant {
  const AttaRestaurant._({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.imageUrl,
    required this.filters,
    required this.description,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.openingHoursSlots,
    required this.dishes,
    required this.menus,
    required this.numberOfReservations,
  });

  factory AttaRestaurant.fromMap(Map<String, dynamic> map) {
    return AttaRestaurant._(
      id: map.parse<int>('id'),
      createdAt: DateTime.tryParse(map.parse<String>('created_at')) ?? DateTime.now(),
      name: map.parse<String>('name', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      filters: map.parse<List>('filters', fallback: []).map(AttaRestaurantFilter.fromValue).toList(),
      description: map.parse<String?>('description'),
      longitude: map.parse<double>('longitude', fallback: 0),
      latitude: map.parse<double>('latitude', fallback: 0),
      address: map.parse<String>('address', fallback: ''),
      phone: map.parse<String>('phone', fallback: ''),
      email: map.parse<String>('email', fallback: ''),
      website: map.parse<String?>('website', fallback: ''),
      openingHoursSlots: map.parse<Map?>('opening_hours_slots', fallback: {})?.map((key, value) {
            return MapEntry(
              AttaDay.fromValue(int.tryParse(key.toString()) ?? 0),
              (value as List).map((e) => AttaOpeningHoursSlots.fromMap(e as Map<String, dynamic>)).toList(),
            );
          }) ??
          {},
      dishes:
          map.parse<List?>('dishes', fallback: [])?.map((e) => AttaDish.fromMap(e as Map<String, dynamic>)).toList() ??
              [],
      menus:
          map.parse<List?>('menus', fallback: [])?.map((e) => AttaMenu.fromMap(e as Map<String, dynamic>)).toList() ??
              [],
      numberOfReservations: map.parse<List>('reservations', fallback: []).length,
    );
  }

  final int id;
  final DateTime createdAt;
  final String name;
  final String address;
  final String imageUrl;
  final List<AttaRestaurantFilter> filters;
  final double longitude;
  final double latitude;
  final String? description;
  final String phone;
  final String email;
  final String? website;
  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingHoursSlots;
  final List<AttaDish> dishes;
  final List<AttaMenu> menus;

  // Only on client side
  final int numberOfReservations;

  num get averagePrice => dishes.fold<num>(0, (previous, e) => previous + e.price) / dishes.length;
  List<AttaFormula> get formulas => [...dishes, ...menus];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
      'image_url': imageUrl,
      'filters': filters.map((e) => e.toString()).toList(),
      'description': description,
      'phone': phone,
      'email': email,
      'website': website,
      'openingTimes': openingHoursSlots.map((key, value) => MapEntry(key.index, value.map((e) => e.toMap()).toList())),
      'dishes': dishes.map((e) => e.toMap()).toList(),
      'menus': menus.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() => toMap().toString();
}

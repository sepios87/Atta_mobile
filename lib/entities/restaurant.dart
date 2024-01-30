import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_hours_slots.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaRestaurant {
  const AttaRestaurant({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.imageUrl,
    required this.filters,
    required this.description,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.website,
    required this.openingHoursSlots,
    required this.dishs,
    required this.menus,
  });

  factory AttaRestaurant.fromMap(Map<String, dynamic> map) {
    return AttaRestaurant(
      id: map.parse<int>('id'),
      createdAt: DateTime.parse(map.parse<String>('created_at')),
      name: map.parse<String>('name', fallback: ''),
      city: map.parse<String>('city', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      filters: map.parse<List?>('filters', fallback: [])?.map(AttaRestaurantFilter.fromValue).toList() ?? [],
      description: map.parse<String?>('description'),
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
      dishs:
          map.parse<List?>('dishs', fallback: [])?.map((e) => AttaDish.fromMap(e as Map<String, dynamic>)).toList() ??
              [],
      menus:
          map.parse<List?>('menus', fallback: [])?.map((e) => AttaMenu.fromMap(e as Map<String, dynamic>)).toList() ??
              [],
    );
  }

  final int id;
  final DateTime createdAt;
  final String name;
  final String address;
  final String city;
  final String imageUrl;
  final List<AttaRestaurantFilter> filters;
  final String? description;
  final String phone;
  final String email;
  final String? website;
  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingHoursSlots;
  final List<AttaDish> dishs;
  final List<AttaMenu> menus;

  String get fullAddress => '$address, $city';
  num get averagePrice => dishs.fold<num>(0, (previous, e) => previous + e.price) / dishs.length;
  List<AttaFormula> get formulas => [...dishs, ...menus];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'image_url': imageUrl,
      'filters': filters.map((e) => e.toString()).toList(),
      'description': description,
      'phone': phone,
      'email': email,
      'website': website,
      'openingTimes': openingHoursSlots.map((key, value) => MapEntry(key.index, value.map((e) => e.toMap()).toList())),
      'dishs': dishs.map((e) => e.toMap()).toList(),
      'menus': menus.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() => toMap().toString();
}

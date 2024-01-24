import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_time.dart';
import 'package:atta/extensions/map_ext.dart';

class AttaRestaurant {
  const AttaRestaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    required this.website,
    required this.openingTimes,
    required this.dishs,
    required this.menus,
  });

  factory AttaRestaurant.fromMap(Map<String, dynamic> map) {
    return AttaRestaurant(
      id: map.parse<int>('id'),
      name: map.parse<String>('name', fallback: ''),
      city: map.parse<String>('city', fallback: ''),
      imageUrl: map.parse<String>('image_url', fallback: ''),
      category: [],
      // map.parse<List>('category', fallback: []).map((e) => AttaCategoryFilter.fromMap(e)).toList(),
      description: map.parse<String?>('description'),
      address: map.parse<String>('address', fallback: ''),
      phone: map.parse<String>('phone', fallback: ''),
      email: map.parse<String>('email', fallback: ''),
      website: map.parse<String?>('website', fallback: ''),
      openingTimes: {},
      dishs: map.parse<List>('dishs', fallback: []).map((e) => AttaDish.fromMap(e as Map<String, dynamic>)).toList(),
      menus: map.parse<List>('menus', fallback: []).map((e) => AttaMenu.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  final int id;
  final String name;
  final String address;
  final String city;
  final String imageUrl;
  final List<AttaCategoryFilter> category;
  final String? description;
  final String phone;
  final String email;
  final String? website;
  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingTimes;
  final List<AttaDish> dishs;
  final List<AttaMenu> menus;

  String get fullAddress => '$address, $city';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'image_url': imageUrl,
      'category': [],
      // category.map((e) => e.toMap()).toList(),
      'description': description,
      'phone': phone,
      'email': email,
      'website': website,
      'openingTimes': [],
      //  openingTimes.map((key, value) => MapEntry(key.toString(), value.map((e) => e.toMap()).toList())),
      'dishs': dishs.map((e) => e.toMap()).toList(),
      'menus': menus.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() => toMap().toString();
}

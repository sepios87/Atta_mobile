import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/opening_time.dart';

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
    required this.dishes,
    required this.menus,
  });

  final String id;
  final String name;
  final String city;
  final String imageUrl;
  final List<AttaCategoryFilter> category;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String website;
  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingTimes;
  final List<AttaDish> dishes;
  final List<AttaMenu> menus;
}

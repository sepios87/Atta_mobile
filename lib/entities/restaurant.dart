import 'package:atta/entities/day.dart';
import 'package:atta/entities/dish.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/menu.dart';
import 'package:flutter/material.dart';

class AttaRestaurant {
  const AttaRestaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.filter,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.openingTimes,
    required this.dishes,
    required this.menus,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<AttaFilter> filter;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String website;
  final Map<Day, List<OpeningTime>> openingTimes;
  final List<Dish> dishes;
  final List<Menu> menus;
}

class OpeningTime {
  const OpeningTime({
    required this.open,
    required this.close,
  });

  final TimeOfDay open;
  final TimeOfDay close;
}

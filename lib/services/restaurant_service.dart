import 'dart:async';

import 'package:atta/entities/dish.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantService {
  final _restaurantsStreamController = BehaviorSubject<List<AttaRestaurant>>();

  Stream get restaurantsStream => _restaurantsStreamController.stream;
  List<AttaRestaurant> get restaurants => _restaurantsStreamController.value;
  bool get isLoaded => _restaurantsStreamController.hasValue;

  Future<void> fetchRestaurants() async {
    try {
      final restaurants = await databaseService.getAllRestaurants();
      _restaurantsStreamController.add(restaurants);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  AttaRestaurant? getRestaurantById(int id) {
    return restaurants.firstWhereOrNull((r) => r.id == id);
  }

  AttaDish? getDishById(int restaurantId, int dishId) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return null;

    return restaurant.dishes.firstWhereOrNull((d) => d.id == dishId);
  }

  AttaMenu? getMenuById(int restaurantId, int menuId) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return null;

    return restaurant.menus.firstWhereOrNull((m) => m.id == menuId);
  }

  List<AttaDish> getDishesFromIds(int restaurantId, List<int> dishIds) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return [];

    return restaurant.dishes.where((d) => dishIds.contains(d.id)).toList();
  }

  List<AttaMenu> getMenusFromIds(int restaurantId, List<int> menuIds) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return [];

    return restaurant.menus.where((m) => menuIds.contains(m.id)).toList();
  }
}

import 'dart:async';

import 'package:atta/entities/dish.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/main.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantService {
  final _restaurantsStreamController = BehaviorSubject<List<AttaRestaurant>>();
  Stream get restaurantsStream => _restaurantsStreamController.stream;

  List<AttaRestaurant> get restaurants => _restaurantsStreamController.value;

  bool get isLoaded => _restaurantsStreamController.hasValue;

  Future<void> fetchRestaurants() async {
    final restaurants = await databaseService.getAllRestaurants();
    print('fetchRestaurants ${restaurants[1]}');
    _restaurantsStreamController.add(restaurants);
  }

  AttaRestaurant? getRestaurantById(int id) {
    return restaurants.firstWhereOrNull((r) => r.id == id);
  }

  AttaDish? getDishById(int restaurantId, int dishId) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return null;

    return restaurant.dishs.firstWhereOrNull((d) => d.id == dishId);
  }
}

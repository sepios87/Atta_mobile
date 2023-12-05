import 'dart:async';

import 'package:atta/entities/dish.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/mock.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantService {
  final _restaurantStreamController = BehaviorSubject<List<AttaRestaurant>>();
  Stream get restaurantStream => _restaurantStreamController.stream;

  List<AttaRestaurant> get lastRestaurantList => _restaurantStreamController.value;

  bool get isLoaded => _restaurantStreamController.hasValue;

  Future<void> fetchRestaurants() async {
    // await Future<void>.delayed(const Duration(seconds: 5));
    _restaurantStreamController.add(mockedData);
  }

  AttaRestaurant? getRestaurantById(String id) {
    return lastRestaurantList.firstWhereOrNull((r) => r.id == id);
  }

  AttaDish? getDishById(String restaurantId, String dishId) {
    final restaurant = getRestaurantById(restaurantId);
    if (restaurant == null) return null;

    return restaurant.dishes.firstWhereOrNull((d) => d.id == dishId);
  }
}

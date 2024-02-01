import 'dart:async';

import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/restaurant_ext.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState.initial(
            restaurants: restaurantService.restaurants,
            user: userService.user,
          ),
        ) {
    _userSubscription = userService.userStream.listen((user) {
      emit(state.copyWith(user: Wrapped.value(user)));
    });
    _loadRestaurantsCategories();
  }

  StreamSubscription<AttaUser?>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _loadRestaurantsCategories() {
    final mostPopularRestaurants = restaurantService.restaurants.getMostPopulars(5);
    final mostRecentRestaurants = restaurantService.restaurants.getMostRecents(5);
    final cheaperRestaurants = restaurantService.restaurants.getCheapers(5);
    final biggestNumberFormulaRestaurants = restaurantService.restaurants.getBiggestNumberFormula(5);
    // other restaurant are restaurantService.restaurants not in mostPopularRestaurants, mostRecentRestaurants and cheaperRestaurants
    final otherRestaurants = restaurantService.restaurants.where((r) {
      return !mostPopularRestaurants.contains(r) &&
          !mostRecentRestaurants.contains(r) &&
          !cheaperRestaurants.contains(r) &&
          !biggestNumberFormulaRestaurants.contains(r);
    }).toList();

    emit(
      state.copyWith(
        mostPopularRestaurants: mostPopularRestaurants,
        mostRecentRestaurants: mostRecentRestaurants,
        cheaperRestaurants: cheaperRestaurants,
        biggestNumberFormulaRestaurants: biggestNumberFormulaRestaurants,
        otherRestaurants: otherRestaurants,
      ),
    );
  }

  void selectFilter(AttaRestaurantFilter filter) {
    final activeFilersCopy = List<AttaRestaurantFilter>.from(state.activeFilters);

    if (activeFilersCopy.contains(filter)) {
      emit(
        state.copyWith(activeFilters: activeFilersCopy..remove(filter)),
      );
    } else {
      emit(
        state.copyWith(activeFilters: activeFilersCopy..add(filter)),
      );
    }
  }

  void onRestaurantSelected(AttaRestaurant restaurant) {
    emit(state.copyWith(selectedRestaurant: Wrapped.value(restaurant)));
  }

  void onRestaurantUnselected() {
    emit(state.copyWith(selectedRestaurant: const Wrapped.value(null)));
  }

  void resetSearch() {
    // _searchController.clear();
    emit(state.copyWith(isOnSearch: false, searchRestaurants: []));
  }

  void onSearchFocusChange(bool isOnSearch) {
    if (state.searchRestaurants.isEmpty) {
      emit(state.copyWith(isOnSearch: isOnSearch));
    }
  }

  void onSearchTextChange(String value) {
    if (value.isNotEmpty) {
      final searchRestaurants = state.restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
      emit(state.copyWith(searchRestaurants: searchRestaurants));
    } else {
      emit(state.copyWith(searchRestaurants: []));
    }
  }

  Future<void> onToogleFavoriteRestaurant(int restaurantId) async {
    await userService.toggleFavoriteRestaurant(restaurantId);
  }
}

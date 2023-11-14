import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void selectFilter(AttaFilter filter) {
    final activeFilersCopy = List<AttaFilter>.from(state.activeFilters);

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
    print('coucou2 $isOnSearch');
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
}

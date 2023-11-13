import 'package:atta/entities/filter.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required FocusNode searchFocusNode,
    required TextEditingController searchController,
  })  : _searchController = searchController,
        _searchFocusNode = searchFocusNode,
        super(HomeState.initial()) {
    _searchFocusNode.addListener(_listenerFocusNode);
    _searchController.addListener(_listenerController);
  }

  final FocusNode _searchFocusNode;
  final TextEditingController _searchController;

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

  void onWillPop() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    } else if (state.isOnSearch) {
      resetSearch();
    }
  }

  void onRestaurantSelected(AttaRestaurant restaurant) {
    emit(state.copyWith(selectedRestaurant: Wrapped.value(restaurant)));
  }

  void onRestaurantUnselected() {
    emit(state.copyWith(selectedRestaurant: const Wrapped.value(null)));
  }

  void resetSearch() {
    _searchController.clear();
    emit(state.copyWith(isOnSearch: false, searchRestaurants: []));
  }

  void _listenerFocusNode() {
    if (_searchFocusNode.hasFocus) {
      emit(state.copyWith(isOnSearch: true));
    } else if (_searchController.text.isEmpty) {
      resetSearch();
    }
  }

  void _listenerController() {
    if (_searchController.text.isNotEmpty) {
      final searchRestaurants = state.restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
      emit(state.copyWith(searchRestaurants: searchRestaurants));
    } else {
      emit(state.copyWith(searchRestaurants: []));
    }
  }
}

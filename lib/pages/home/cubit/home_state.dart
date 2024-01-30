part of 'home_cubit.dart';

@immutable
final class HomeState {
  const HomeState._({
    required this.restaurants,
    required this.searchRestaurants,
    required this.activeFilters,
    required this.isOnSearch,
    required this.selectedRestaurant,
    required this.user,
  });

  HomeState.initial({
    AttaUser? user,
    List<AttaRestaurant>? restaurants,
  }) : this._(
          restaurants: restaurants ?? [],
          searchRestaurants: [],
          activeFilters: [],
          isOnSearch: false,
          selectedRestaurant: null,
          user: user,
        );

  final List<AttaRestaurant> restaurants;
  final List<AttaRestaurant> searchRestaurants;
  final List<AttaRestaurantFilter> activeFilters;

  final AttaRestaurant? selectedRestaurant;
  final AttaUser? user;

  final bool isOnSearch;

  List<AttaRestaurant> get filteredRestaurants => filterRestaurants(restaurants);
  List<AttaRestaurant> get filteredSearchRestaurants => filterRestaurants(searchRestaurants);

  List<AttaRestaurant> filterRestaurants(List<AttaRestaurant> list) {
    if (activeFilters.isEmpty) return list;

    return list.where((r) => r.filters.any(activeFilters.contains)).toList();
  }

  HomeState copyWith({
    List<AttaRestaurant>? restaurants,
    List<AttaRestaurant>? searchRestaurants,
    List<AttaRestaurantFilter>? activeFilters,
    bool? isOnSearch,
    Wrapped<AttaRestaurant?>? selectedRestaurant,
    Wrapped<AttaUser?>? user,
  }) {
    return HomeState._(
      restaurants: restaurants ?? this.restaurants,
      searchRestaurants: searchRestaurants ?? this.searchRestaurants,
      activeFilters: activeFilters ?? this.activeFilters,
      isOnSearch: isOnSearch ?? this.isOnSearch,
      selectedRestaurant: selectedRestaurant != null ? selectedRestaurant.value : this.selectedRestaurant,
      user: user != null ? user.value : this.user,
    );
  }
}
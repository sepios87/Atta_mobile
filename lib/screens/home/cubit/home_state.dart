part of 'home_cubit.dart';

@immutable
final class HomeState {
  const HomeState._({
    required this.restaurants,
    required this.searchRestaurants,
    required this.activeFilters,
    required this.isOnSearch,
    required this.selectedRestaurant,
  });

  factory HomeState.initial() {
    return HomeState._(
      restaurants: List.filled(
        10,
        const AttaRestaurant(
          id: 'id',
          name: 'Papa burger',
          imageUrl: 'https://picsum.photos/200/300',
          filter: [AttaFilter.burger],
        ),
      ),
      searchRestaurants: const [],
      activeFilters: const [],
      isOnSearch: false,
      selectedRestaurant: null,
    );
  }

  final List<AttaRestaurant> restaurants;
  final List<AttaRestaurant> searchRestaurants;
  final List<AttaFilter> activeFilters;

  final AttaRestaurant? selectedRestaurant;

  final bool isOnSearch;

  List<AttaRestaurant> get filteredRestaurants => filterRestaurants(restaurants);
  List<AttaRestaurant> get filteredSearchRestaurants => filterRestaurants(searchRestaurants);

  List<AttaRestaurant> filterRestaurants(List<AttaRestaurant> list) {
    if (activeFilters.isEmpty) return list;

    return list.where((r) => r.filter.any(activeFilters.contains)).toList();
  }

  HomeState copyWith({
    List<AttaRestaurant>? restaurants,
    List<AttaRestaurant>? searchRestaurants,
    List<AttaFilter>? activeFilters,
    bool? isOnSearch,
    Wrapped<AttaRestaurant?>? selectedRestaurant,
  }) {
    return HomeState._(
      restaurants: restaurants ?? this.restaurants,
      searchRestaurants: searchRestaurants ?? this.searchRestaurants,
      activeFilters: activeFilters ?? this.activeFilters,
      isOnSearch: isOnSearch ?? this.isOnSearch,
      selectedRestaurant: selectedRestaurant != null ? selectedRestaurant.value : this.selectedRestaurant,
    );
  }
}

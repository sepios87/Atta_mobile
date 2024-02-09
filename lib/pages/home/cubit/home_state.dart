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
    required this.mostPopularRestaurants,
    required this.mostRecentRestaurants,
    required this.cheaperRestaurants,
    required this.otherRestaurants,
    required this.biggestNumberFormulaRestaurants,
    required this.isOnListView,
  });

  HomeState.initial({
    required List<AttaRestaurant> restaurants,
    AttaUser? user,
  }) : this._(
          restaurants: restaurants,
          searchRestaurants: [],
          activeFilters: [],
          isOnSearch: false,
          selectedRestaurant: null,
          user: user,
          mostPopularRestaurants: [],
          mostRecentRestaurants: [],
          cheaperRestaurants: [],
          otherRestaurants: [],
          biggestNumberFormulaRestaurants: [],
          isOnListView: true,
        );

  final List<AttaRestaurant> restaurants;
  final List<AttaRestaurant> searchRestaurants;
  final List<AttaRestaurantFilter> activeFilters;

  final List<AttaRestaurant> mostPopularRestaurants;
  final List<AttaRestaurant> mostRecentRestaurants;
  final List<AttaRestaurant> cheaperRestaurants;
  final List<AttaRestaurant> biggestNumberFormulaRestaurants;
  final List<AttaRestaurant> otherRestaurants;

  final AttaRestaurant? selectedRestaurant;
  final AttaUser? user;

  final bool isOnSearch;
  final bool isOnListView;

  List<AttaRestaurant> filterRestaurants(List<AttaRestaurant> list) {
    if (activeFilters.isEmpty) return list;
    print('restaurants activeFilters: ${activeFilters.map((e) => e.name).toList()}');
    print('restaurants activeFilters----***: ${list.map((e) => e.filters).toList()}');

    return list.where((r) => r.filters.any(activeFilters.contains)).toList();
  }

  HomeState copyWith({
    List<AttaRestaurant>? restaurants,
    List<AttaRestaurant>? searchRestaurants,
    List<AttaRestaurantFilter>? activeFilters,
    bool? isOnSearch,
    Wrapped<AttaRestaurant?>? selectedRestaurant,
    Wrapped<AttaUser?>? user,
    List<AttaRestaurant>? mostPopularRestaurants,
    List<AttaRestaurant>? mostRecentRestaurants,
    List<AttaRestaurant>? cheaperRestaurants,
    List<AttaRestaurant>? biggestNumberFormulaRestaurants,
    List<AttaRestaurant>? otherRestaurants,
    bool? isOnListView,
  }) {
    return HomeState._(
      restaurants: restaurants ?? this.restaurants,
      searchRestaurants: searchRestaurants ?? this.searchRestaurants,
      activeFilters: activeFilters ?? this.activeFilters,
      isOnSearch: isOnSearch ?? this.isOnSearch,
      selectedRestaurant: selectedRestaurant != null ? selectedRestaurant.value : this.selectedRestaurant,
      user: user != null ? user.value : this.user,
      mostPopularRestaurants: mostPopularRestaurants ?? this.mostPopularRestaurants,
      mostRecentRestaurants: mostRecentRestaurants ?? this.mostRecentRestaurants,
      cheaperRestaurants: cheaperRestaurants ?? this.cheaperRestaurants,
      biggestNumberFormulaRestaurants: biggestNumberFormulaRestaurants ?? this.biggestNumberFormulaRestaurants,
      otherRestaurants: otherRestaurants ?? this.otherRestaurants,
      isOnListView: isOnListView ?? this.isOnListView,
    );
  }
}

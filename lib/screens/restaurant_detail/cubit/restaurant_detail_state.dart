part of 'restaurant_detail_cubit.dart';

@immutable
class RestaurantDetailState {
  const RestaurantDetailState._({
    required this.restaurant,
    required this.selectedDate,
    required this.selectedOpeningTime,
    required this.selectedFormulaFilter,
    required this.searchValue,
  });

  RestaurantDetailState.initial({
    required AttaRestaurant restaurant,
  }) : this._(
          restaurant: restaurant,
          selectedDate: DateTime.now(),
          selectedOpeningTime: null,
          selectedFormulaFilter: null,
          searchValue: '',
        );

  final AttaRestaurant restaurant;
  final DateTime selectedDate;
  final TimeOfDay? selectedOpeningTime;
  final AttaFormulaFilter? selectedFormulaFilter;
  final String searchValue;

  bool get isOnSearch => searchValue.isNotEmpty;

  RestaurantDetailState copyWith({
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
    Wrapped<AttaFormulaFilter?>? selectedFormulaFilter,
    String? searchValue,
  }) {
    return RestaurantDetailState._(
      restaurant: restaurant,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedOpeningTime: selectedOpeningTime != null ? selectedOpeningTime.value : this.selectedOpeningTime,
      selectedFormulaFilter: selectedFormulaFilter != null ? selectedFormulaFilter.value : this.selectedFormulaFilter,
      searchValue: searchValue ?? this.searchValue,
    );
  }
}

part of 'restaurant_detail_cubit.dart';

@immutable
class RestaurantDetailState {
  const RestaurantDetailState._({
    required this.restaurant,
    required this.selectedDate,
    required this.selectedOpeningTime,
    required this.selectedFormulaType,
    required this.searchValue,
    required this.isFavorite,
  });

  const RestaurantDetailState.initial({
    required AttaRestaurant restaurant,
    required DateTime selectedDate,
    required TimeOfDay? selectedOpeningTime,
    required bool isFavorite,
  }) : this._(
          restaurant: restaurant,
          selectedDate: selectedDate,
          selectedOpeningTime: selectedOpeningTime,
          selectedFormulaType: null,
          searchValue: '',
          isFavorite: isFavorite,
        );

  final AttaRestaurant restaurant;
  final DateTime selectedDate;
  final TimeOfDay? selectedOpeningTime;
  final AttaFormulaType? selectedFormulaType;
  final String searchValue;
  final bool isFavorite;

  bool get isOnSearch => searchValue.isNotEmpty;
  List<AttaFormula> get filteredFormulas {
    final filteredFormulas =
        restaurant.formulas.where((e) => selectedFormulaType?.isFormulaSameType(e) ?? true).toList();

    if (isOnSearch) {
      filteredFormulas.retainWhere(
        (f) => f.name.toLowerCase().contains(searchValue.toLowerCase()),
      );
    }
    return filteredFormulas;
  }

  RestaurantDetailState copyWith({
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
    Wrapped<AttaFormulaType?>? selectedFormulaType,
    String? searchValue,
  }) {
    return RestaurantDetailState._(
      restaurant: restaurant,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedOpeningTime: selectedOpeningTime != null ? selectedOpeningTime.value : this.selectedOpeningTime,
      selectedFormulaType: selectedFormulaType != null ? selectedFormulaType.value : this.selectedFormulaType,
      searchValue: searchValue ?? this.searchValue,
      isFavorite: isFavorite,
    );
  }
}

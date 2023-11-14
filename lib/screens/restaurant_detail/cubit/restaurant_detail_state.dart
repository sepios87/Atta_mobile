part of 'restaurant_detail_cubit.dart';

@immutable
class RestaurantDetailState {
  const RestaurantDetailState._({
    required this.restaurant,
    required this.selectedDate,
    required this.selectedOpeningTime,
  });

  RestaurantDetailState.initial({
    required AttaRestaurant restaurant,
  }) : this._(
          restaurant: restaurant,
          selectedDate: DateTime.now(),
          selectedOpeningTime: null,
        );

  final AttaRestaurant restaurant;
  final DateTime selectedDate;
  final TimeOfDay? selectedOpeningTime;

  RestaurantDetailState copyWith({
    AttaRestaurant? restaurant,
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
  }) {
    return RestaurantDetailState._(
      restaurant: restaurant ?? this.restaurant,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedOpeningTime: selectedOpeningTime != null ? selectedOpeningTime.value : this.selectedOpeningTime,
    );
  }
}

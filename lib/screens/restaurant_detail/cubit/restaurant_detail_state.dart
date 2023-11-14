part of 'restaurant_detail_cubit.dart';

@immutable
class RestaurantDetailState {
  const RestaurantDetailState._({
    required this.restaurant,
  });

  const RestaurantDetailState.initial({
    required AttaRestaurant restaurant,
  }) : this._(
          restaurant: restaurant,
        );

  final AttaRestaurant restaurant;
}

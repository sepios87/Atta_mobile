part of 'favorite_cubit.dart';

@immutable
final class FavoriteState {
  const FavoriteState._({
    required this.user,
    required List<AttaRestaurant> restaurants,
  }) : _restaurants = restaurants;

  factory FavoriteState.initial({
    required AttaUser user,
    required List<AttaRestaurant> restaurants,
  }) =>
      FavoriteState._(user: user, restaurants: restaurants);

  final AttaUser user;
  final List<AttaRestaurant> _restaurants;

  List<AttaRestaurant> get favoriteRestaurants =>
      _restaurants.where((restaurant) => user.favoritesRestaurantIds.contains(restaurant.id)).toList();

  List<(AttaDish, int restaurantId)> get favoriteDishs {
    final dishes = _restaurants.expand((restaurant) => restaurant.dishes).toList();
    final favoriteDishes = user.favoriteDishesIds.map((dishId) {
      final dish = dishes.firstWhere((dish) => dish.id == dishId.$1);
      return (dish, dishId.$2);
    }).toList();
    return favoriteDishes;
  }

  FavoriteState copyWith({AttaUser? user}) {
    return FavoriteState._(
      user: user ?? this.user,
      restaurants: _restaurants,
    );
  }
}

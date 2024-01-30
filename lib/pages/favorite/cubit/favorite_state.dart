part of 'favorite_cubit.dart';

@immutable
final class FavoriteState {
  const FavoriteState._({
    required this.user,
    required List<AttaRestaurant> restaurants,
  }) : _restaurants = restaurants;

  factory FavoriteState.initial({
    required AttaUser? user,
    required List<AttaRestaurant> restaurants,
  }) =>
      FavoriteState._(user: user, restaurants: restaurants);

  final AttaUser? user;
  final List<AttaRestaurant> _restaurants;

  List<AttaRestaurant> get favoriteRestaurants =>
      _restaurants.where((restaurant) => user?.favoritesRestaurantIds.contains(restaurant.id) ?? false).toList();

  FavoriteState copyWith({Wrapped<AttaUser?>? user}) {
    return FavoriteState._(
      user: user != null ? user.value : this.user,
      restaurants: _restaurants,
    );
  }
}

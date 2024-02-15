part of '../db_service.dart';

extension DatabaseRestaurantService on DatabaseService {
  Future<List<AttaRestaurant>> getAllRestaurants() async {
    try {
      // Not necessary to get dish into menu now
      final data = await _supabase.from('restaurants').select(
            '*, dishes(*), menus(*, disheIds:dishes(id)), reservations(restaurant_id)',
          );
      return data.map(AttaRestaurant.fromMap).toList();
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> removeFavoriteRestaurant(int restaurantId) async {
    try {
      if (currentUser == null) throw Exception('User not found');
      await _supabase
          .from('favorite_restaurants')
          .delete()
          .eq('user_id', currentUser!.id)
          .eq('restaurant_id', restaurantId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addFavoriteRestaurant(int restaurantId) async {
    if (currentUser == null) throw Exception('User not found');
    await _supabase.from('favorite_restaurants').insert({'user_id': currentUser!.id, 'restaurant_id': restaurantId});
  }

  Future<void> removeFavoriteDish(int restaurantId, int dishId) async {
    try {
      if (currentUser == null) throw Exception('User not found');
      final dishRestaurant =
          await _supabase.from('dish_restaurant').select('id').eq('restaurant_id', restaurantId).eq('dish_id', dishId);

      if (dishRestaurant.isEmpty) throw Exception('Dish not found');

      await _supabase
          .from('favorite_dishes')
          .delete()
          .eq('user_id', currentUser!.id)
          .eq('dish_restaurant_id', dishRestaurant.first['id'].toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addFavoriteDish(int restaurantId, int dishId) async {
    if (currentUser == null) throw Exception('User not found');
    try {
      final dishRestaurant =
          await _supabase.from('dish_restaurant').select('id').eq('restaurant_id', restaurantId).eq('dish_id', dishId);

      if (dishRestaurant.isEmpty) throw Exception('Dish not found');

      await _supabase.from('favorite_dishes').insert({
        'user_id': currentUser!.id,
        'dish_restaurant_id': dishRestaurant.first['id'].toString(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

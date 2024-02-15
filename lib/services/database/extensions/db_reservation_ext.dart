part of '../db_service.dart';

extension DatabaseReservationExt on DatabaseService {
  Future<void> addDishToReservation({
    required int dishId,
    required int restaurantId,
  }) async {}

  Future<void> removeDishToReservation({
    required int dishId,
    required int restaurantId,
  }) async {}

  Future<Map<AttaDish, int>> getReservationDishes(int reservationId) async {
    final data =
        await _supabase.from('dish_reservation').select('*, dish:dishes(*)').eq('reservation_id', reservationId);

    final dishesWithQuantity = data
        .map(
          (e) => MapEntry(
            AttaDish.fromMap(e['dish'] as Map<String, dynamic>),
            int.tryParse(e['quantity'].toString()) ?? 0,
          ),
        )
        .toList();

    return Map.fromEntries(dishesWithQuantity);
  }

  Future<int> createReservation(AttaReservation reservation) async {
    final reservationMap = reservation.toMapForDb();
    reservationMap['user_id'] = currentUser?.id;
    final data = await _supabase.from('reservations').upsert(reservationMap).select('id');
    final reservationId = int.parse(data.first['id'].toString());

    for (final dishId in reservation.dishIds.keys) {
      await _supabase.from('dish_reservation').insert({
        'reservation_id': reservationId,
        'dish_id': dishId,
        'quantity': reservation.dishIds[dishId],
      });
    }

    for (final menu in reservation.menus) {
      await _supabase.from('menu_reservation').insert({
        'reservation_id': reservationId,
        'menu_id': menu.menuId,
        'selected_dishes_ids_list': menu.selectedDishIds.toList(),
      });
    }

    return reservationId;
  }

  Future<Map<String, dynamic>> getReservation(int reservationId) async {
    final data = await _supabase
        .from('reservations')
        .select('*, dish_reservation(*), menu_reservation(*)')
        .eq('id', reservationId);
    return data.first;
  }

  Future<void> removeReservation(int reservationId) async {
    await _supabase.from('reservations').delete().eq('id', reservationId);
  }
}

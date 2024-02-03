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

  Future<Map<AttaDish, int>> getReservationDishs(int reservationId) async {
    final data =
        await _supabase.from('dish_reservation').select('*, dish:dishs(*)').eq('reservation_id', reservationId);

    final dishsWithQuantity = data
        .map(
          (e) => MapEntry(
            AttaDish.fromMap(e['dish'] as Map<String, dynamic>),
            int.tryParse(e['quantity'].toString()) ?? 0,
          ),
        )
        .toList();

    return Map.fromEntries(dishsWithQuantity);
  }

  Future<Map<String, dynamic>> createReservation(AttaReservation reservation) async {
    final reservationMap = reservation.toMapForDb();
    reservationMap['user_id'] = currentUser?.id;
    final data = await _supabase.from('reservations').upsert(reservationMap).select();

    for (final dish in reservation.dishs?.keys.toList() ?? <AttaDish>[]) {
      await _supabase.from('dish_reservation').insert({
        'reservation_id': data.first['id'],
        'dish_id': dish.id,
        'quantity': reservation.dishs![dish],
      });
    }

    return data.first;
  }

  Future<void> removeReservation(int reservationId) async {
    await _supabase.from('reservations').delete().eq('id', reservationId);
  }
}

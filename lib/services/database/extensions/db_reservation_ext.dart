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

  Future<List<AttaDish>> getReservationDishs(int reservationId) async {
    final data =
        await _supabase.from('dish_reservation').select('reservation_id, dishs(*)').eq('reservation_id', reservationId);
    final rawDishs = data.map((e) => e['dishs']).toList();
    return rawDishs.map((e) => AttaDish.fromMap(e as Map<String, dynamic>)).toList();
  }
}

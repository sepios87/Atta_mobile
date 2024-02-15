import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:flutter/material.dart';

class ReservationService {
  final _reservations = <int, AttaReservation>{};

  TimeOfDay? _selectedTime;
  DateTime _selectedDate = DateTime.now();

  TimeOfDay? get selectedTime => _selectedTime;
  DateTime? get selectedDate => _selectedDate;
  AttaReservation? getReservation(int restaurantId) => _reservations[restaurantId];

  void setReservationDateTime({
    required int restaurantId,
    Wrapped<TimeOfDay?>? time,
    DateTime? date,
  }) {
    if (date != null) _selectedDate = date;
    if (time != null) {
      if (time.value == null) {
        _selectedTime = null;
      } else {
        _selectedTime = time.value;
        final newDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        final currentReservation =
            _reservations[restaurantId] ?? AttaReservation.fromRestaurantId(restaurantId: restaurantId);

        _reservations[restaurantId] = currentReservation.copyWith(dateTime: newDateTime);
      }
    }
  }

  void addDishToReservation({
    required int restaurantId,
    required int dishId,
    required int quantity,
  }) {
    final currentReservation =
        _reservations[restaurantId] ?? AttaReservation.fromRestaurantId(restaurantId: restaurantId);

    final newDishes = Map.of(currentReservation.dishIds);
    newDishes[dishId] = quantity;
    _reservations[restaurantId] = currentReservation.copyWith(dishIds: newDishes);
  }

  void addMenuToReservation({
    required int restaurantId,
    required int menuId,
    required int quantity,
    required Set<int> selectedDishIds,
  }) {
    final currentReservation =
        _reservations[restaurantId] ?? AttaReservation.fromRestaurantId(restaurantId: restaurantId);
    final newMenus = Set.of(currentReservation.menus)
      ..add(
        AttaMenuReservation.fromValues(
          menuId: menuId,
          selectedDishIds: selectedDishIds,
        ),
      );
    _reservations[restaurantId] = currentReservation.copyWith(menus: newMenus);
  }

  void removeDishFromReservation({
    required int restaurantId,
    required int dishId,
  }) {
    final currentReservation = _reservations[restaurantId];
    if (currentReservation != null) {
      final newDishIds = Map.of(currentReservation.dishIds)..remove(dishId);
      _reservations[restaurantId] = currentReservation.copyWith(dishIds: newDishIds);
    }
  }

  Future<Map<String, dynamic>> sendReservation(AttaReservation reservation) async {
    final data = await databaseService.createReservation(reservation);
    userService.addOrUpdateReservation(AttaReservation.fromMap(data));

    // Remove local reservation in progress after sending it to the server
    _reservations.remove(reservation.restaurantId);
    resetReservationDateTime();

    return data;
  }

  void resetReservationDateTime() {
    _selectedTime = null;
    _selectedDate = DateTime.now();
  }

  Future<void> removeReservation(int reservationId) async {
    await databaseService.removeReservation(reservationId);
    userService.removeReservation(reservationId);
  }

  double calculateTotalAmount(AttaReservation reservation) {
    final dishes = restaurantService.getDishesFromIds(reservation.restaurantId, reservation.dishIds.keys.toList());
    final dishesPrice = dishes.fold<double>(0, (p, d) => p + d.price * reservation.dishIds[d.id]!);

    final menus =
        restaurantService.getMenusFromIds(reservation.restaurantId, reservation.menus.map((e) => e.menuId).toList());

    final menusPrice =
        reservation.menus.fold<double>(0, (p, menu) => p + menus.firstWhere((m) => m.id == menu.menuId).price);

    return dishesPrice + menusPrice;
  }
}

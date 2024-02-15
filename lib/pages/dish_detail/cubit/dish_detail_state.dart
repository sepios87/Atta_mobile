part of 'dish_detail_cubit.dart';

@immutable
class DishDetailState {
  const DishDetailState._({
    required this.dish,
    required this.quantity,
    required this.restaurantId,
    required this.isFavorite,
    this.reservation,
  });

  factory DishDetailState.initial({
    required AttaDish dish,
    required int restaurantId,
    required bool isFavorite,
    AttaReservation? reservation,
  }) {
    return DishDetailState._(
      dish: dish,
      quantity: reservation?.dishIds[dish.id] ?? 1,
      restaurantId: restaurantId,
      isFavorite: isFavorite,
      reservation: reservation,
    );
  }

  final AttaDish dish;
  final int quantity;
  final int restaurantId;
  final AttaReservation? reservation;
  final bool isFavorite;

  bool get isDeletable => reservation?.dishIds.containsKey(dish.id) ?? false;

  DishDetailState copyWith({
    int? quantity,
  }) {
    return DishDetailState._(
      dish: dish,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId,
      isFavorite: isFavorite,
    );
  }
}

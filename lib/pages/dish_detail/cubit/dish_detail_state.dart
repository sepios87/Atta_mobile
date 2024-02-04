part of 'dish_detail_cubit.dart';

@immutable
class DishDetailState {
  const DishDetailState._({
    required this.dish,
    required this.quantity,
    required this.restaurantId,
    this.reservation,
  });

  factory DishDetailState.initial({
    required AttaDish dish,
    required int restaurantId,
    AttaReservation? reservation,
  }) {
    final quantity = reservation?.dishes?[dish] ?? 1;

    return DishDetailState._(
      dish: dish,
      quantity: quantity,
      restaurantId: restaurantId,
      reservation: reservation,
    );
  }

  final AttaDish dish;
  final int quantity;
  final int restaurantId;
  final AttaReservation? reservation;

  bool get isDeletable => reservation?.dishes?.containsKey(dish) ?? false;

  DishDetailState copyWith({
    int? quantity,
  }) {
    return DishDetailState._(
      dish: dish,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId,
    );
  }
}

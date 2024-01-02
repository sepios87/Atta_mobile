part of 'dish_detail_cubit.dart';

@immutable
class DishDetailState {
  const DishDetailState._({
    required this.dish,
    required this.quantity,
  });

  factory DishDetailState.initial({required AttaDish dish}) {
    return DishDetailState._(
      dish: dish,
      quantity: 1,
    );
  }

  final AttaDish dish;
  final int quantity;

  DishDetailState copyWith({
    int? quantity,
  }) {
    return DishDetailState._(
      dish: dish,
      quantity: quantity ?? this.quantity,
    );
  }
}

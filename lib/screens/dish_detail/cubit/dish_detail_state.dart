part of 'dish_detail_cubit.dart';

@immutable
class DishDetailState {
  const DishDetailState._({
    required this.dish,
  });

  factory DishDetailState.initial({required AttaDish dish}) {
    return DishDetailState._(
      dish: dish,
    );
  }

  final AttaDish dish;
}

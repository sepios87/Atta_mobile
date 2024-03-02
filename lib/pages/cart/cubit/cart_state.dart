part of 'cart_cubit.dart';

@immutable
final class CartState {
  const CartState._({
    required this.reservations,
  });

  factory CartState.initial(List<AttaReservation> reservations) {
    return CartState._(
      reservations: reservations,
    );
  }

  final List<AttaReservation> reservations;

  CartState copyWith({List<AttaReservation>? reservations}) {
    return CartState._(
      reservations: reservations ?? this.reservations,
    );
  }
}

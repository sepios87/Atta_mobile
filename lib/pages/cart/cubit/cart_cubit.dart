import 'package:atta/entities/reservation.dart';
import 'package:atta/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial(reservationService.reservations));

  void refresh() {
    emit(state.copyWith(reservations: reservationService.reservations));
  }
}

import 'dart:async';

import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_reservations_state.dart';

class UserReservationsCubit extends Cubit<UserReservationsState> {
  UserReservationsCubit() : super(UserReservationsState.initial(userService.user!)) {
    _userSubscription = userService.userStream.listen((user) {
      emit(state.copyWith(user: user));
    });
  }

  StreamSubscription<AttaUser?>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();

    return super.close();
  }

  Future<void> onExpandReservation(AttaReservation reservation) async {
    if (reservation.dishes != null) return;

    emit(state.copyWith(status: UserReservationsLoading(reservation.id)));
    try {
      await reservationService.fetchReservationWithDishes(reservation);
    } catch (e) {
      emit(state.copyWith(status: UserReservationsError(e.toString())));
    }
    emit(state.copyWith(status: UserReservationsIdle()));
  }

  Future<void> onRemoveReservation(AttaReservation reservation) async {
    try {
      await reservationService.removeReservation(reservation.id!);
    } catch (e) {
      emit(state.copyWith(status: UserReservationsError(e.toString())));
    }
    emit(state.copyWith(status: UserReservationsIdle()));
  }
}

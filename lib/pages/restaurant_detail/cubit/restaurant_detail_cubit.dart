import 'package:atta/entities/day.dart';
import 'package:atta/entities/filter.dart';
import 'package:atta/entities/formula.dart';
import 'package:atta/entities/reservation.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/extensions/opening_time_ext.dart';
import 'package:atta/extensions/restaurant_ext.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

part 'restaurant_detail_state.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit({
    required int restaurantId,
  }) : super(
          RestaurantDetailState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
            selectedDate: reservationService.selectedDate ?? DateTime.now(),
            selectedOpeningTime: reservationService.selectedTime,
            isFavorite: userService.user?.favoritesRestaurantIds.contains(restaurantId) ?? false,
            reservation: reservationService.getReservation(restaurantId),
          ),
        );

  @override
  Future<void> close() {
    reservationService.resetReservationDateTime();

    return super.close();
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, selectedOpeningTime: const Wrapped.value(null)));
    reservationService.setReservationDateTime(
      restaurantId: state.restaurant.id,
      time: const Wrapped.value(null),
      date: date,
    );
  }

  void selectFirstOpeningTime() {
    final openingTimes = state.restaurant.openingHoursSlots.getTimesOfDay(AttaDay.fromDateTime(state.selectedDate));
    if (openingTimes.isNotEmpty) {
      selectOpeningTime(openingTimes.first);
    }
  }

  void selectOpeningTime(TimeOfDay time) {
    if (state.selectedOpeningTime == time) {
      emit(state.copyWith(selectedOpeningTime: const Wrapped.value(null)));
      reservationService.setReservationDateTime(
        restaurantId: state.restaurant.id,
        time: const Wrapped.value(null),
      );
    } else {
      emit(state.copyWith(selectedOpeningTime: Wrapped.value(time)));
      reservationService.setReservationDateTime(
        restaurantId: state.restaurant.id,
        time: Wrapped.value(time),
      );
    }
  }

  void selectFormulaFilter(AttaFormulaType type) {
    if (state.selectedFormulaType == type) {
      emit(state.copyWith(selectedFormulaType: const Wrapped.value(null)));
    } else {
      emit(state.copyWith(selectedFormulaType: Wrapped.value(type)));
    }
  }

  void onSearchTextChange(String value) {
    emit(state.copyWith(searchValue: value));
  }

  Future<void> onToogleFavoriteRestaurant() async {
    await userService.toggleFavoriteRestaurant(state.restaurant.id);
  }

  void updateReservation() {
    emit(state.copyWith(reservation: reservationService.getReservation(state.restaurant.id)));
  }

  void onShare() {
    Share.share(state.restaurant.shareText());
  }
}

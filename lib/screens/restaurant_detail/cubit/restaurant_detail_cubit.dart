import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'restaurant_detail_state.dart';

class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  RestaurantDetailCubit({
    required String restaurantId,
  }) : super(
          RestaurantDetailState.initial(
            restaurant: restaurantService.getRestaurantById(restaurantId)!,
          ),
        );

  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedOpeningTime: const Wrapped.value(null),
      ),
    );
  }

  void selectOpeningTime(TimeOfDay time) {
    emit(state.copyWith(selectedOpeningTime: Wrapped.value(time)));
  }
}

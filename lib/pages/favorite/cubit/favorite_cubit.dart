import 'dart:async';

import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/entities/wrapped.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit()
      : super(
          FavoriteState.initial(
            user: userService.user,
            restaurants: restaurantService.restaurants,
          ),
        ) {
    _userSubscription = userService.userStream.listen((user) {
      emit(state.copyWith(user: Wrapped.value(user)));
    });
  }

  StreamSubscription<AttaUser?>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Future<void> onUnlikedRestaurant(int restaurantId) async {
    await userService.toggleFavoriteRestaurant(restaurantId);
  }
}

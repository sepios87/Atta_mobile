import 'dart:async';

import 'package:atta/entities/dish.dart';
import 'package:atta/entities/restaurant.dart';
import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit()
      : super(
          FavoriteState.initial(
            user: userService.user!,
            restaurants: restaurantService.restaurants,
          ),
        ) {
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

  Future<void> onUnlikedRestaurant(int restaurantId) async {
    await userService.toggleFavoriteRestaurant(restaurantId);
  }

  Future<void> onUnlikedDish(int restaurantId, int dishId) async {
    await userService.toggleFavoriteDish(
      restaurantId: restaurantId,
      dishId: dishId,
    );
  }
}

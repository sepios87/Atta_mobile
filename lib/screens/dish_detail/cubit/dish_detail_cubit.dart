import 'package:atta/entities/dish.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dish_detail_state.dart';

class DishDetailCubit extends Cubit<DishDetailState> {
  DishDetailCubit({
    required String restaurantId,
    required String dishId,
  }) : super(
          DishDetailState.initial(
            dish: restaurantService.getDishById(restaurantId, dishId)!,
          ),
        );
}

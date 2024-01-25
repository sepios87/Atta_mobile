import 'dart:async';

import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_state.dart';

class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit()
      : super(
          BottomNavigationState.initial(user: userService.user),
        ) {
    _userStreamSubscription = userService.userStream.listen((user) {
      emit(state.copyWith(user: user));
    });
  }

  StreamSubscription<AttaUser?>? _userStreamSubscription;

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();

    return super.close();
  }
}

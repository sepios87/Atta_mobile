import 'dart:async';

import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_base_state.dart';

class HomeBaseCubit extends Cubit<HomeBaseState> {
  HomeBaseCubit() : super(HomeBaseState.initial(user: userService.user)) {
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
}

import 'package:atta/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'preload_state.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit() : super(PreloadState.initial()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(status: PreloadLoadingStatus()));
    await Future<void>.delayed(const Duration(seconds: 1));
    try {
      await _executeInBackground();
      emit(state.copyWith(status: PreloadLoadedStatus()));
    } catch (e) {
      emit(state.copyWith(status: PreloadErrorStatus(e.toString())));
    }
  }
}

// Use flutter-isolate to execute the preload in background and access to flutter plugins
@pragma('vm:entry-point')
Future<void> _executeInBackground() async {
  await userService.init();
  await restaurantService.fetchRestaurants();
}

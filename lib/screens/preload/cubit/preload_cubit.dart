import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'preload_state.dart';

class PreloadCubit extends Cubit<PreloadState> {
  PreloadCubit() : super(PreloadState.initial()) {
    _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(status: PreloadLoadingStatus()));
    try {
      await restaurantService.fetchRestaurants();
      emit(state.copyWith(status: PreloadLoadedStatus()));
    } catch (e) {
      emit(state.copyWith(status: PreloadErrorStatus(e.toString())));
    }
  }
}

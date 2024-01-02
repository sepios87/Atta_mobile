import 'package:atta/entities/wrapped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationState.initial());

  void onTableSelected(String tableId) {
    if (state.selectedTableId == tableId) {
      emit(state.copyWith(selectedTableId: const Wrapped.value(null)));
    } else {
      emit(state.copyWith(selectedTableId: Wrapped.value(tableId)));
    }
  }
}

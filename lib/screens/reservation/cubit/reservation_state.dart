part of 'reservation_cubit.dart';

@immutable
final class ReservationState {
  const ReservationState._({
    required this.selectedTableId,
  });

  factory ReservationState.initial() => const ReservationState._(
        selectedTableId: null,
      );

  final String? selectedTableId;

  ReservationState copyWith({
    Wrapped<String?>? selectedTableId,
  }) {
    return ReservationState._(
      selectedTableId: selectedTableId == null ? this.selectedTableId : selectedTableId.value,
    );
  }
}

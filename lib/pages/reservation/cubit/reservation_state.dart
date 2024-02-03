part of 'reservation_cubit.dart';

@immutable
final class ReservationState {
  const ReservationState._({
    required this.selectedTableId,
    required this.restaurant,
    required this.selectedOpeningTime,
    required this.selectedDate,
    required this.numberOfPersons,
    required this.reservation,
    required this.status,
  });

  factory ReservationState.initial({
    required AttaRestaurant restaurant,
    required TimeOfDay? selectedTime,
    required DateTime selectedDate,
    AttaReservation? reservation,
  }) =>
      ReservationState._(
        selectedTableId: null,
        restaurant: restaurant,
        selectedOpeningTime: selectedTime,
        selectedDate: selectedDate,
        numberOfPersons: 2,
        reservation: reservation,
        status: ReservationIdleStatus(),
      );

  final String? selectedTableId;
  final AttaRestaurant restaurant;
  final TimeOfDay? selectedOpeningTime;
  final DateTime selectedDate;
  final int numberOfPersons;
  final AttaReservation? reservation;
  final ReservationStatus status;

  ReservationState copyWith({
    Wrapped<String?>? selectedTableId,
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
    int? numberOfPersons,
    ReservationStatus? status,
  }) {
    return ReservationState._(
      restaurant: restaurant,
      selectedOpeningTime: selectedOpeningTime == null ? this.selectedOpeningTime : selectedOpeningTime.value,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTableId: selectedTableId == null ? this.selectedTableId : selectedTableId.value,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      reservation: reservation,
      status: status ?? this.status,
    );
  }
}

@immutable
abstract final class ReservationStatus {}

final class ReservationIdleStatus extends ReservationStatus {}

final class ReservationLoadingStatus extends ReservationStatus {}

final class ReservationSuccessStatus extends ReservationStatus {}

final class ReservationErrorStatus extends ReservationStatus {
  ReservationErrorStatus(this.message);

  final String message;
}

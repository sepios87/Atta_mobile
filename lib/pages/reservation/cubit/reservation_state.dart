part of 'reservation_cubit.dart';

@immutable
final class ReservationState {
  const ReservationState._({
    required this.restaurant,
    required this.selectedOpeningTime,
    required this.selectedDate,
    required this.reservation,
    required this.status,
  });

  factory ReservationState.initial({
    required AttaRestaurant restaurant,
    required TimeOfDay? selectedTime,
    required DateTime selectedDate,
    required AttaReservation reservation,
  }) =>
      ReservationState._(
        restaurant: restaurant,
        selectedOpeningTime: selectedTime,
        selectedDate: selectedDate,
        reservation: reservation,
        status: ReservationIdleStatus(),
      );

  final AttaRestaurant restaurant;
  final TimeOfDay? selectedOpeningTime;
  final DateTime selectedDate;
  final AttaReservation reservation;
  final ReservationStatus status;

  bool isSelectableTable(AttaTable table, int numberOfSeats) {
    final tableNumberOfSeats = table.numberOfSeats;
    // Permet d'éviter de reserver une table avec plus de places que nécessaire (ou trop peu de place)
    return numberOfSeats >= tableNumberOfSeats - 1 && numberOfSeats <= tableNumberOfSeats;
  }

  ReservationState copyWith({
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
    ReservationStatus? status,
    AttaReservation? reservation,
  }) {
    return ReservationState._(
      restaurant: restaurant,
      selectedOpeningTime: selectedOpeningTime == null ? this.selectedOpeningTime : selectedOpeningTime.value,
      selectedDate: selectedDate ?? this.selectedDate,
      reservation: reservation ?? this.reservation,
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

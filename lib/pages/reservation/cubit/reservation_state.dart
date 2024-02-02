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
      );

  final String? selectedTableId;
  final AttaRestaurant restaurant;
  final TimeOfDay? selectedOpeningTime;
  final DateTime selectedDate;
  final int numberOfPersons;
  final AttaReservation? reservation;

  ReservationState copyWith({
    Wrapped<String?>? selectedTableId,
    DateTime? selectedDate,
    Wrapped<TimeOfDay?>? selectedOpeningTime,
    int? numberOfPersons,
  }) {
    return ReservationState._(
      restaurant: restaurant,
      selectedOpeningTime: selectedOpeningTime == null ? this.selectedOpeningTime : selectedOpeningTime.value,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTableId: selectedTableId == null ? this.selectedTableId : selectedTableId.value,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      reservation: reservation,
    );
  }
}

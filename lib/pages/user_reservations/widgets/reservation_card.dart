part of '../user_reservations_page.dart';

class _ReservationCard extends StatelessWidget {
  const _ReservationCard(this.reservation);

  final AttaReservation reservation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('///${reservation.id}///'),
        Text('${reservation.restaurantId}'),
        Text('${reservation.createdAt}'),
      ],
    );
  }
}

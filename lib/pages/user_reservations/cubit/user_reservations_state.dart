part of 'user_reservations_cubit.dart';

@immutable
final class UserReservationsState {
  const UserReservationsState._({
    required this.user,
    required this.status,
    required this.selectedReservations,
  });

  factory UserReservationsState.initial(AttaUser user) {
    return UserReservationsState._(
      user: user,
      status: UserReservationsIdle(),
      selectedReservations: const [],
    );
  }

  final AttaUser user;
  final UserReservationsStatus status;
  final List<AttaReservation> selectedReservations;

  UserReservationsState copyWith({
    AttaUser? user,
    UserReservationsStatus? status,
    List<AttaReservation>? selectedReservations,
  }) {
    return UserReservationsState._(
      user: user ?? this.user,
      status: status ?? this.status,
      selectedReservations: selectedReservations ?? this.selectedReservations,
    );
  }
}

@immutable
abstract final class UserReservationsStatus {}

final class UserReservationsIdle extends UserReservationsStatus {}

final class UserReservationsLoading extends UserReservationsStatus {
  UserReservationsLoading(this.reservationId);

  final int? reservationId;
}

final class UserReservationsError extends UserReservationsStatus {
  UserReservationsError(this.message);

  final String message;
}

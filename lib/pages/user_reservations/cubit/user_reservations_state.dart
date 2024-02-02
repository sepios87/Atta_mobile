part of 'user_reservations_cubit.dart';

@immutable
final class UserReservationsState {
  const UserReservationsState._({
    required this.user,
    required this.status,
  });

  factory UserReservationsState.initial(AttaUser user) {
    return UserReservationsState._(
      user: user,
      status: UserReservationsIdle(),
    );
  }

  final AttaUser user;
  final UserReservationsStatus status;

  UserReservationsState copyWith({
    AttaUser? user,
    UserReservationsStatus? status,
  }) {
    return UserReservationsState._(
      user: user ?? this.user,
      status: status ?? this.status,
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

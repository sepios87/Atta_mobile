part of 'user_reservations_cubit.dart';

@immutable
final class UserReservationsState {
  const UserReservationsState._({
    required this.user,
  });

  factory UserReservationsState.initial(AttaUser user) {
    return UserReservationsState._(
      user: user,
    );
  }

  final AttaUser user;

  UserReservationsState copyWith({
    AttaUser? user,
  }) {
    return UserReservationsState._(
      user: user ?? this.user,
    );
  }
}

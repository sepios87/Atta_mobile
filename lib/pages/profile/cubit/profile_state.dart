part of 'profile_cubit.dart';

@immutable
final class ProfileState {
  const ProfileState._({required this.user, required this.status});

  factory ProfileState.initial(AttaUser user) {
    return ProfileState._(user: user, status: ProfileIdleStatus());
  }

  final AttaUser user;
  final ProfileStatus status;

  ProfileState copyWith({
    AttaUser? user,
    ProfileStatus? status,
  }) {
    return ProfileState._(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}

@immutable
abstract final class ProfileStatus {}

final class ProfileIdleStatus extends ProfileStatus {}

final class ProfileLoadingLogoutStatus extends ProfileStatus {}

final class ProfileErrorStatus extends ProfileStatus {
  ProfileErrorStatus(this.error);

  final Object error;
}

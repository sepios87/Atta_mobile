part of 'auth_cubit.dart';

@immutable
class AttaAuthState {
  const AttaAuthState._({
    required this.status,
  });

  factory AttaAuthState.initial() {
    return AttaAuthState._(
      status: AuthLoginStatus(),
    );
  }

  final AuthStatus status;

  AttaAuthState copyWith({
    AuthStatus? status,
  }) {
    return AttaAuthState._(
      status: status ?? this.status,
    );
  }
}

final class AuthStatus {
  const AuthStatus();
}

final class AuthLoginStatus extends AuthStatus {}

final class AuthRegisterStatus extends AuthStatus {}

final class AuthErrorStatus extends AuthStatus {
  const AuthErrorStatus(this.message);

  final String message;
}

final class AuthSuccessStatus extends AuthStatus {}

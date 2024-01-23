part of 'auth_cubit.dart';

@immutable
class AuthState {
  const AuthState._({
    required this.status,
  });

  factory AuthState.initial() {
    return AuthState._(
      status: AuthLoginStatus(),
    );
  }

  final AuthStatus status;

  AuthState copyWith({
    AuthStatus? status,
  }) {
    return AuthState._(
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

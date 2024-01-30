part of 'auth_cubit.dart';

@immutable
class AttaAuthState {
  const AttaAuthState._({
    required this.status,
    required this.isLogin,
  });

  factory AttaAuthState.initial() {
    return AttaAuthState._(
      status: AuthIdleStatus(),
      isLogin: true,
    );
  }

  final AuthStatus status;
  final bool isLogin;

  AttaAuthState copyWith({
    AuthStatus? status,
    bool? isLoginForm,
  }) {
    return AttaAuthState._(
      status: status ?? this.status,
      isLogin: isLoginForm ?? this.isLogin,
    );
  }
}

abstract class AuthStatus {
  const AuthStatus();
}

final class AuthIdleStatus extends AuthStatus {}

final class AuthLoadingStatus extends AuthStatus {}

final class AuthLoadingForgetPasswordStatus extends AuthStatus {}

final class AuthLoadingGoogleStatus extends AuthStatus {}

final class AuthErrorStatus extends AuthStatus {
  const AuthErrorStatus(this.message);

  final String message;
}

final class AuthSuccessStatus extends AuthStatus {}

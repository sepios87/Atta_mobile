part of 'auth_cubit.dart';

@immutable
class AttaAuthState {
  const AttaAuthState._({
    required this.status,
    required this.isLogin,
    required this.isNewAccount,
  });

  factory AttaAuthState.initial() {
    return AttaAuthState._(
      status: AuthIdleStatus(),
      isLogin: true,
      isNewAccount: false,
    );
  }

  final AuthStatus status;
  final bool isLogin;
  final bool isNewAccount;

  AttaAuthState copyWith({
    AuthStatus? status,
    bool? isLoginForm,
    bool? isNewAccount,
  }) {
    return AttaAuthState._(
      status: status ?? this.status,
      isLogin: isLoginForm ?? isLogin,
      isNewAccount: isNewAccount ?? this.isNewAccount,
    );
  }
}

@immutable
abstract final class AuthStatus {}

final class AuthIdleStatus extends AuthStatus {}

final class AuthLoadingStatus extends AuthStatus {}

final class AuthLoadingForgetPasswordStatus extends AuthStatus {}

final class AuthLoadingGoogleStatus extends AuthStatus {}

final class AuthErrorStatus extends AuthStatus {
  AuthErrorStatus(this.message);

  final String message;
}

final class AuthSuccessStatus extends AuthStatus {}

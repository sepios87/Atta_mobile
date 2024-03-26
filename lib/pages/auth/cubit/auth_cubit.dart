import 'package:atta/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AttaAuthState> {
  AuthCubit() : super(AttaAuthState.initial());

  void onLogin() {
    emit(state.copyWith(isLoginForm: true));
  }

  void onRegister() {
    emit(state.copyWith(isLoginForm: false));
  }

  Future<void> onCreateAccount(String email, String password) async {
    emit(state.copyWith(status: AuthLoadingStatus()));
    try {
      await userService.createAccount(email, password);
      emit(state.copyWith(status: AuthSuccessStatus(), isNewAccount: true));
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
      emit(state.copyWith(status: AuthIdleStatus()));
    }
  }

  Future<void> onSendLogin(String email, String password) async {
    emit(state.copyWith(status: AuthLoadingStatus()));
    try {
      await userService.login(email, password);
      emit(state.copyWith(status: AuthSuccessStatus()));
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
      emit(state.copyWith(status: AuthIdleStatus()));
    }
  }

  Future<void> onSendForgetPassword(String email) async {
    emit(state.copyWith(status: AuthLoadingForgetPasswordStatus()));
    try {
      await userService.forgetPassword(email);
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
    }
    emit(state.copyWith(status: AuthIdleStatus()));
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthLoadingGoogleStatus()));
    try {
      await userService.signInWithGoogle();
      emit(state.copyWith(status: AuthSuccessStatus()));
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
      emit(state.copyWith(status: AuthIdleStatus()));
    }
  }
}

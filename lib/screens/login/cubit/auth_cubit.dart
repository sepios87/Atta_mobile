import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  void onLogin() {
    emit(state.copyWith(status: AuthLoginStatus()));
  }

  void onRegister() {
    emit(state.copyWith(status: AuthRegisterStatus()));
  }

  Future<void> onCreateAccount(String email, String password) async {
    try {
      await userService.createAccount(email, password);
      emit(state.copyWith(status: AuthSuccessStatus()));
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
      emit(state.copyWith(status: AuthLoginStatus()));
    }
  }

  Future<void> onSendLogin(String email, String password) async {
    try {
      await userService.login(email, password);
      emit(state.copyWith(status: AuthSuccessStatus()));
    } catch (e) {
      emit(state.copyWith(status: AuthErrorStatus(e.toString())));
      emit(state.copyWith(status: AuthLoginStatus()));
    }
  }
}

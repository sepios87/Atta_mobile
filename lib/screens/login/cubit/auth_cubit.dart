import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  void onLogin() {
    emit(state.copyWith(status: AuthLoginStatus()));
  }

  void onSendLogin(String email, String password) {
    userService.login(email, password);
  }

  void onRegister() {
    emit(state.copyWith(status: AuthRegisterStatus()));
  }
}

import 'dart:async';

import 'package:atta/entities/user.dart';
import 'package:atta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial(userService.user!)) {
    _userStreamSubscription = userService.userStream.listen((user) {
      if (user?.id != state.user.id) {
        emit(state.copyWith(user: user));
      }
    });
  }

  StreamSubscription<AttaUser?>? _userStreamSubscription;

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();

    return super.close();
  }

  Future<void> onLogout() async {
    emit(state.copyWith(status: ProfileLoadingLogoutStatus()));
    try {
      await userService.logout();
    } catch (e) {
      emit(state.copyWith(status: ProfileErrorStatus(e)));
      emit(state.copyWith(status: ProfileIdleStatus()));
    }
  }

  Future<void> onChangeLanguage(BuildContext context, String languageCode) async {
    try {
      await changeLocale(context, languageCode);
      await userService.updateLanguage(languageCode);
    } catch (e) {
      emit(state.copyWith(status: ProfileErrorStatus(e)));
      emit(state.copyWith(status: ProfileIdleStatus()));
    }
  }
}

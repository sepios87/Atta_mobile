import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/home/home_screen.dart';
import 'package:atta/screens/login/cubit/auth_cubit.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets/password_field.dart';
part 'widgets/login.dart';
part 'widgets/register.dart';

class LoginPage {
  static const path = '/login';
  static const routeName = 'login';

  static Widget getScreen() => BlocProvider(
        create: (context) => AuthCubit(),
        child: const _AuthScreen(),
      );
}

class _AuthScreen extends StatelessWidget {
  const _AuthScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.adaptativePopNamed(HomePage.routeName),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(AttaSpacing.xl),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: SingleChildScrollView(
          child: BlocSelector<AuthCubit, AuthState, AuthStatus>(
            selector: (state) => state.status,
            builder: (context, status) {
              if (status is AuthRegisterStatus) {
                return const _RegisterContent();
              }
              return const _LoginContent();
            },
          ),
        ),
      ),
    );
  }
}

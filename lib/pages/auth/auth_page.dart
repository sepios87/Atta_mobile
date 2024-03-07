import 'package:atta/bottom_sheet/edit_profile.dart';
import 'package:atta/extensions/border_radius_ext.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/pages/auth/cubit/auth_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

part 'widgets/password_field.dart';
part 'widgets/login.dart';
part 'widgets/create_account.dart';

class AuthPage {
  static const path = '/auth';
  static const routeName = 'auth';

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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusExt.top(AttaRadius.medium),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AttaSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: AttaSpacing.xl),
              Text(translate('auth_page.welcome'), style: AttaTextStyle.header.copyWith(fontSize: 36)),
              const SizedBox(height: AttaSpacing.xl),
              Text(translate('auth_page.content'), textAlign: TextAlign.center, style: AttaTextStyle.content),
              const SizedBox(height: AttaSpacing.l),
              BlocConsumer<AuthCubit, AttaAuthState>(
                listener: (context, state) async {
                  final status = state.status;

                  if (status is AuthErrorStatus) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(status.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  if (status is AuthSuccessStatus) {
                    final user = userService.user;
                    if (!state.isLogin && user != null) {
                      await showEditProfileBottomSheet(context, user);
                    }
                    // ignore: use_build_context_synchronously
                    context.adaptativePopNamed(HomePage.routeName);
                  }
                },
                buildWhen: (previous, current) => previous.isLogin != current.isLogin,
                builder: (context, state) {
                  if (state.isLogin) return const _LoginContent();

                  return const _CreateAccountContent();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

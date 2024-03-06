import 'package:atta/entities/user.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/string_ext.dart';
import 'package:atta/extensions/widget_ext.dart';
import 'package:atta/pages/auth/auth_page.dart';
import 'package:atta/pages/cart/cart_page.dart';
import 'package:atta/pages/favorite/favorite_page.dart';
import 'package:atta/pages/home/home_base/cubit/home_base_cubit.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/profile/profile_page.dart';
import 'package:atta/pages/user_reservations/user_reservations_page.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

part 'widgets/app_bar.dart';
part 'widgets/bottom_navigation_bar.dart';

class HomeBase extends StatelessWidget {
  const HomeBase({
    required this.child,
    required this.path,
    super.key,
  });

  final Widget child;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBaseCubit(),
      child: BlocBuilder<HomeBaseCubit, HomeBaseState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _AttaAppBar(user: state.user),
            body: child,
            bottomNavigationBar: state.user == null ? null : _AttaBottomNavigationBar(path: path),
          );
        },
      ),
    );
  }
}

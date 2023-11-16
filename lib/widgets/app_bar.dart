import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/login/login_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class AttaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => context.adapativePushNamed(LoginPage.routeName),
        child: Text(
          'Se connecter',
          style: AttaTextStyle.subHeader.copyWith(
            color: AttaColors.white,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

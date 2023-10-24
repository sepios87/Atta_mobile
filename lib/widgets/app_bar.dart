import 'package:atta/theme/colors.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () => context.push('/login'),
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

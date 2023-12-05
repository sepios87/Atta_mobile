import 'package:atta/entities/user.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/screens/login/login_screen.dart';
import 'package:atta/screens/user/user_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class AttaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttaAppBar({super.key, this.user});

  final AttaUser? user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        radius: AttaRadius.small,
        onTap: () {
          if (user == null) {
            context.adapativePushNamed(LoginPage.routeName);
          } else {
            context.adapativePushNamed(UserPage.routeName);
          }
        },
        child: user == null
            ? Text(
                'Se connecter',
                style: AttaTextStyle.subHeader.copyWith(
                  color: AttaColors.white,
                ),
              )
            : Row(
                children: [
                  if (user!.imageUrl != null)
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(user!.imageUrl!),
                    ),
                  const SizedBox(width: AttaSpacing.m),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user!.lastName != null)
                        Text(
                          user!.lastName!,
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                          ),
                        ),
                      if (user!.firstName != null)
                        Text(
                          user!.firstName!,
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
      ),
      actions: [
        if (user != null)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        const SizedBox(width: AttaSpacing.m),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

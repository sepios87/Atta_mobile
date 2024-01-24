import 'package:atta/entities/user.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/extensions/user_ext.dart';
import 'package:atta/main.dart';
import 'package:atta/screens/login/login_screen.dart';
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
        borderRadius: BorderRadius.circular(AttaRadius.full),
        onTap: () {
          if (user == null) {
            context.adapativePushNamed(LoginPage.routeName);
          } else {
            // TODO(florian): add user page
            userService.logout();
            // context.adapativePushNamed(UserPage.routeName);
          }
        },
        child: user == null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AttaSpacing.s,
                  horizontal: AttaSpacing.m,
                ),
                child: Text(
                  'Se connecter',
                  style: AttaTextStyle.subHeader.copyWith(
                    color: AttaColors.white,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: user!.imageUrl != null ? NetworkImage(user!.imageUrl!) : null,
                    backgroundColor: AttaColors.primary,
                    child: user!.imageUrl == null
                        ? user?.anagram == null
                            ? Icon(
                                Icons.person,
                                color: AttaColors.white,
                              )
                            : Text(
                                user!.anagram!,
                                style: AttaTextStyle.caption.copyWith(
                                  color: AttaColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                        : null,
                  ),
                  if (user?.firstName != null || user?.lastName != null) const SizedBox(width: AttaSpacing.m),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user!.lastName != null)
                        Text(
                          user!.lastName![0].toUpperCase(),
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                          ),
                        ),
                      if (user!.firstName != null)
                        Text(
                          user!.firstName![0].toUpperCase(),
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

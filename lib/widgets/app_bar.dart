import 'package:atta/entities/user.dart';
import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/auth/auth_page.dart';
import 'package:atta/pages/profile/profile_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

class AttaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttaAppBar({super.key, this.user});

  final AttaUser? user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: InkWell(
        borderRadius: BorderRadius.circular(AttaRadius.full),
        onTap: () {
          if (user == null) {
            context.adapativePushNamed(AuthPage.routeName);
          } else {
            context.adapativePushNamed(ProfilePage.routeName);
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
                  UserAvatar(user: user!),
                  if (user?.firstName != null || user?.lastName != null) const SizedBox(width: AttaSpacing.m),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user!.lastName != null)
                        Text(
                          user!.firstName != null ? user!.lastName![0].toUpperCase() : user!.lastName!,
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                          ),
                        ),
                      if (user!.firstName != null)
                        Text(
                          user!.lastName != null ? user!.firstName![0].toUpperCase() : user!.firstName!,
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  if (user?.firstName != null || user?.lastName != null) const SizedBox(width: AttaSpacing.m),
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

import 'package:atta/entities/user.dart';
import 'package:atta/extensions/user_ext.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.radius = 18,
    super.key,
  });

  final AttaUser user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: user.imageUrl == null ? AttaColors.primary : Colors.transparent,
      child: user.imageUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.imageUrl!,
                fadeInDuration: const Duration(milliseconds: 300),
              ),
            )
          : user.anagram == null
              ? Icon(
                  Icons.person,
                  color: AttaColors.white,
                  size: radius,
                )
              : Text(
                  user.anagram!,
                  style: AttaTextStyle.caption.copyWith(
                    color: AttaColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
    );
  }
}

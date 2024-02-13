import 'package:atta/entities/user.dart';
import 'package:atta/extensions/user_ext.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.user,
    this.radius = 18,
    this.withoutImage = false,
    super.key,
  });

  final AttaUser user;
  final double radius;
  final bool withoutImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: user.imageUrl == null || withoutImage ? AttaColors.primary : Colors.transparent,
      child: user.imageUrl != null && !withoutImage
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.imageUrl!,
                maxWidthDiskCache: 1000,
                maxHeightDiskCache: 1000,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                useOldImageOnUrlChange: true,
                fadeInDuration: AttaAnimation.mediumAnimation,
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
                    fontSize: radius - 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
    );
  }
}

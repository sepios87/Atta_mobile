import 'package:atta/entities/restaurant.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    required this.restaurant,
    this.positionedWidget,
    this.onTap,
    this.showFilters = true,
    super.key,
  });

  final AttaRestaurant restaurant;
  final Positioned? positionedWidget;
  final void Function()? onTap;
  final bool showFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AttaRadius.small),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: restaurant.thumbnail,
                width: double.infinity,
                height: 98,
                maxWidthDiskCache: 1000,
                maxHeightDiskCache: 1000,
                useOldImageOnUrlChange: true,
                fit: BoxFit.cover,
                fadeInDuration: AttaAnimation.mediumAnimation,
                imageBuilder: (context, imageProvider) {
                  return Material(
                    child: Ink.image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      child: InkWell(
                        splashColor: AttaColors.black.withOpacity(0.2),
                        onTap: onTap,
                      ),
                    ),
                  );
                },
                placeholder: (context, _) => const AttaSkeleton(size: Size(double.infinity, 98)),
              ),
              if (positionedWidget != null) positionedWidget!,
            ],
          ),
        ),
        const SizedBox(height: AttaSpacing.xxs),
        Flexible(
          child: Text(
            restaurant.name,
            overflow: TextOverflow.ellipsis,
            style: AttaTextStyle.subHeader,
          ),
        ),
        if (restaurant.filters.isNotEmpty && showFilters)
          Text(
            restaurant.filters.first.translatedName,
            style: AttaTextStyle.content,
          ),
      ],
    );
  }
}

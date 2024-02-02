import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FormulaCard extends StatelessWidget {
  const FormulaCard({
    required this.formula,
    this.onTap,
    this.quantity,
    this.badge,
    super.key,
  });

  final AttaFormula formula;
  final void Function()? onTap;
  final int? quantity;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final imageHeight = (formula.description?.length ?? 0) > 60 ? 86.0 : 68.0;

    return Material(
      color: formula is AttaMenu ? AttaColors.white : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.m,
            vertical: AttaSpacing.s,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: imageHeight,
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: formula.imageUrl,
                    fit: BoxFit.cover,
                    maxWidthDiskCache: 1000,
                    maxHeightDiskCache: 1000,
                    useOldImageOnUrlChange: true,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, _) {
                      return AttaSkeleton(size: Size(68, imageHeight));
                    },
                  ),
                ),
                const SizedBox(width: AttaSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${formula.name} ${quantity != null ? 'x$quantity' : ''}', style: AttaTextStyle.subHeader),
                      if (formula.description != null) ...[
                        const SizedBox(height: AttaSpacing.xs),
                        Text(
                          formula.description!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AttaSpacing.m),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (badge != null) ...[
                      badge!,
                      const Spacer(),
                    ],
                    Text(
                      (formula.price * (quantity ?? 1)).toEuro,
                      style: AttaTextStyle.caption.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

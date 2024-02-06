import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/extensions/num_ext.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
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
    this.suffixName,
    super.key,
  });

  final AttaFormula formula;
  final void Function()? onTap;
  final int? quantity;
  final Widget? badge;
  final String? suffixName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: formula is AttaMenu ? AttaColors.white : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.m,
            vertical: AttaSpacing.s,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 68),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 68),
                    width: 68,
                    height: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: formula.imageUrl,
                        fit: BoxFit.cover,
                        maxWidthDiskCache: 1000,
                        maxHeightDiskCache: 1000,
                        useOldImageOnUrlChange: true,
                        fadeInDuration: AttaAnimation.mediumAnimation,
                        placeholder: (context, _) => const AttaSkeleton(size: Size(68, 68)),
                      ),
                    ),
                  ),
                  const SizedBox(width: AttaSpacing.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${formula.name} ${suffixName ?? ''} ${quantity != null ? 'x$quantity' : ''}',
                          style: AttaTextStyle.subHeader,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
      ),
    );
  }
}

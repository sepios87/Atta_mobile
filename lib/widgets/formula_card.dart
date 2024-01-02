import 'package:atta/entities/formula.dart';
import 'package:atta/entities/menu.dart';
import 'package:atta/extensions/double_ext.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:atta/widgets/skeleton.dart';
import 'package:flutter/material.dart';

class FormulaCard extends StatelessWidget {
  const FormulaCard({
    required this.formula,
    this.onTap,
    super.key,
  });

  final AttaFormula formula;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final imageHeight = formula.description.length > 60 ? 86.0 : 68.0;

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: imageHeight,
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                  child: Image.network(
                    formula.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return AttaSkeleton(
                        size: Size(68, imageHeight),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AttaSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formula.name, style: AttaTextStyle.subHeader),
                      const SizedBox(height: AttaSpacing.xs),
                      Text(
                        formula.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AttaSpacing.m),
                Text(
                  formula.price.toEuro,
                  style: AttaTextStyle.caption.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

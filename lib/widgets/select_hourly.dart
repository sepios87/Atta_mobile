import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class SelectHourly extends StatelessWidget {
  const SelectHourly({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Réserve ton morceau', style: AttaTextStyle.label),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Text("Aujourd'hui", style: AttaTextStyle.label),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(width: AttaSpacing.s),
            itemBuilder: (context, index) => _TimeItem(time: '12:00'),
          ),
        )
      ],
    );
  }
}

class _TimeItem extends StatelessWidget {
  const _TimeItem({
    required this.time,
    super.key,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AttaSpacing.s,
        vertical: AttaSpacing.xxs,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AttaRadius.small),
        color: AttaColors.secondary,
      ),
      child: Center(
        child: Text(
          time,
          style: AttaTextStyle.label.copyWith(
            color: AttaColors.white,
          ),
        ),
      ),
    );
  }
}

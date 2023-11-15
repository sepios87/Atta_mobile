import 'package:atta/entities/day.dart';
import 'package:atta/entities/opening_time.dart';
import 'package:atta/extensions/date_time_ext.dart';
import 'package:atta/extensions/opening_time_ext.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class SelectHourly extends StatelessWidget {
  const SelectHourly({
    required this.openingTimes,
    required this.selectedOpeningTime,
    required this.onOpeningTimeChanged,
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  final Map<AttaDay, List<AttaOpeningTime>> openingTimes;
  final TimeOfDay? selectedOpeningTime;
  final void Function(TimeOfDay) onOpeningTimeChanged;

  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;

  @override
  Widget build(BuildContext context) {
    final openingTimesOfDay = openingTimes.getTimesOfDay(AttaDay.fromDateTime(selectedDate));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Réserve ton morceau', style: AttaTextStyle.label),
            TextButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  onDateChanged(date);
                }
              },
              child: Row(
                children: [
                  Text(selectedDate.format, style: AttaTextStyle.label),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 32,
          child: openingTimesOfDay.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: AttaColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AttaRadius.small),
                  ),
                  child: Center(
                    child: Text(
                      'Aucun horaire trouvé',
                      style: AttaTextStyle.label.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: openingTimesOfDay.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AttaSpacing.s),
                  itemBuilder: (context, index) => _TimeItem(
                    time: openingTimesOfDay[index].format(context),
                    onTap: () => onOpeningTimeChanged(openingTimesOfDay[index]),
                    isSelected: openingTimesOfDay[index] == selectedOpeningTime,
                  ),
                ),
        ),
      ],
    );
  }
}

class _TimeItem extends StatelessWidget {
  const _TimeItem({
    required this.time,
    required this.onTap,
    required this.isSelected,
  });

  final String time;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.s,
            vertical: AttaSpacing.xxs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AttaRadius.small),
            color: isSelected ? AttaColors.primaryLight : AttaColors.secondary,
          ),
          child: Center(
            child: Text(
              time,
              style: AttaTextStyle.caption.copyWith(
                color: AttaColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
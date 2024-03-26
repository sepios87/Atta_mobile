import 'package:atta/entities/day.dart';
import 'package:atta/entities/opening_hours_slots.dart';
import 'package:atta/extensions/date_time_ext.dart';
import 'package:atta/extensions/opening_time_ext.dart';
import 'package:atta/theme/animation.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

const kSelectHourlyHeight = 32.0;

class SelectHourly extends StatelessWidget {
  const SelectHourly({
    required this.openingTimes,
    required this.selectedOpeningTime,
    required this.onOpeningTimeChanged,
    required this.selectedDate,
    required this.onDateChanged,
    super.key,
  });

  final Map<AttaDay, List<AttaOpeningHoursSlots>> openingTimes;
  final TimeOfDay? selectedOpeningTime;
  final void Function(TimeOfDay) onOpeningTimeChanged;

  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;

  @override
  Widget build(BuildContext context) {
    final openingTimesOfDay = openingTimes.getTimesOfDay(AttaDay.fromDateTime(selectedDate));

    Future<void> onShowDatePicker() async {
      final date = await showDatePicker(
        context: context,
        initialDate: openingTimesOfDay.isNotEmpty ? selectedDate : null,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        selectableDayPredicate: (date) => openingTimes.containsKey(AttaDay.fromDateTime(date)),
      );
      if (date != null) onDateChanged(date);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onShowDatePicker,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Row(
            children: [
              Text(translate('select_hourly.title'), style: AttaTextStyle.subHeader),
              const Spacer(),
              Text(selectedDate.format(), style: AttaTextStyle.label),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        SizedBox(
          height: 32,
          child: openingTimesOfDay.isEmpty
              ? GestureDetector(
                  onTap: onShowDatePicker,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AttaColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AttaRadius.small),
                    ),
                    child: Center(
                      child: Text(
                        'Le restaurant est fermé ${selectedDate.format().toLowerCase()}',
                        style: AttaTextStyle.label,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: openingTimesOfDay.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AttaSpacing.s),
                  itemBuilder: (context, index) => _TimeItem(
                    time: openingTimesOfDay.elementAt(index).format(context),
                    onTap: () => onOpeningTimeChanged(openingTimesOfDay.elementAt(index)),
                    isSelected: openingTimesOfDay.elementAt(index) == selectedOpeningTime,
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
          duration: AttaAnimation.fastAnimation,
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AttaSpacing.s,
            vertical: AttaSpacing.xxs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AttaRadius.small),
            color: isSelected ? AttaColors.primary : AttaColors.secondary,
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

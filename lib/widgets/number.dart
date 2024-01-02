import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class AttaNumber extends StatelessWidget {
  const AttaNumber({
    required this.onChange,
    required this.quantity,
    this.isVertical = false,
    super.key,
  });

  final void Function(int) onChange;
  final int quantity;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    final addButton = SizedBox.square(
      dimension: 32,
      child: IconButton(
        onPressed: () => onChange(quantity + 1),
        icon: Icon(Icons.add, color: AttaColors.black),
        iconSize: 16,
      ),
    );

    final removeButton = SizedBox.square(
      dimension: 32,
      child: IconButton(
        onPressed: quantity == 1 ? null : () => onChange(quantity - 1),
        icon: Icon(Icons.remove, color: AttaColors.black),
        iconSize: 16,
      ),
    );

    final widgetList = [
      if (isVertical) addButton else removeButton,
      SizedBox(
        width: isVertical ? 28 : 64,
        child: TextField(
          controller: TextEditingController(text: quantity.toString()),
          textAlign: TextAlign.center,
          style: AttaTextStyle.caption,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AttaRadius.full),
              borderSide: BorderSide(color: AttaColors.black, width: 2),
            ),
            contentPadding: EdgeInsets.only(
              left: 3,
              top: isVertical ? AttaSpacing.l : AttaSpacing.xxs,
              bottom: isVertical ? AttaSpacing.l : AttaSpacing.xxs,
            ),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              onChange(int.parse(value));
            }
          },
        ),
      ),
      if (isVertical) removeButton else addButton,
    ];

    return isVertical ? Column(children: widgetList) : Row(children: widgetList);
  }
}

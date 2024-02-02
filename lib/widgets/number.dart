import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class AttaNumber extends StatefulWidget {
  const AttaNumber({
    required this.onChange,
    required this.initialValue,
    this.isVertical = false,
    this.minValue = 1,
    super.key,
  });

  final void Function(int) onChange;
  final int initialValue;
  final bool isVertical;
  final int minValue;

  @override
  State<AttaNumber> createState() => _AttaNumberState();
}

class _AttaNumberState extends State<AttaNumber> {
  late final _controller = TextEditingController(text: widget.initialValue.toString());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChange() {
    if (_controller.text.isNotEmpty) {
      widget.onChange(int.parse(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    final addButton = SizedBox.square(
      dimension: 36,
      child: IconButton(
        onPressed: () {
          final value = int.parse(_controller.text);
          _controller.text = (value + 1).toString();
          _onChange();
        },
        icon: Icon(Icons.add, color: AttaColors.black),
        iconSize: 18,
      ),
    );

    final removeButton = SizedBox.square(
      dimension: 36,
      child: IconButton(
        onPressed: () {
          final value = int.parse(_controller.text);
          if (value > widget.minValue) {
            _controller.text = (value - 1).toString();
            _onChange();
          }
        },
        icon: Icon(Icons.remove, color: AttaColors.black),
        iconSize: 18,
      ),
    );

    final widgetList = [
      if (widget.isVertical) addButton else removeButton,
      SizedBox(
        width: widget.isVertical ? 28 : 64,
        child: TextField(
          controller: _controller,
          textAlign: TextAlign.center,
          style: AttaTextStyle.caption,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AttaRadius.full),
              borderSide: BorderSide(color: AttaColors.black, width: 2),
            ),
            contentPadding: EdgeInsets.only(
              left: 3,
              top: widget.isVertical ? AttaSpacing.l : AttaSpacing.xxs,
              bottom: widget.isVertical ? AttaSpacing.l : AttaSpacing.xxs,
            ),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.onChange(int.parse(value));
            }
          },
        ),
      ),
      if (widget.isVertical) removeButton else addButton,
    ];

    return widget.isVertical ? Column(children: widgetList) : Row(children: widgetList);
  }
}

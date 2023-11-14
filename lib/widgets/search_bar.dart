import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';

class AttaSearchBar extends StatefulWidget {
  const AttaSearchBar({
    required this.onFocus,
    required this.onSearch,
    super.key,
  });

  final void Function(bool) onFocus;
  final void Function(String) onSearch;

  @override
  State<AttaSearchBar> createState() => _AttaSearchBarState();
}

class _AttaSearchBarState extends State<AttaSearchBar> {
  final _focusNode = FocusNode();
  final _textEditingController = TextEditingController();

  bool _isOnSearch = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_listenerFocusNode);
    _textEditingController.addListener(_listenerController);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_listenerFocusNode)
      ..dispose();

    _textEditingController
      ..removeListener(_listenerController)
      ..dispose();
    super.dispose();
  }

  void _listenerController() {
    widget.onSearch(_textEditingController.text);
  }

  void _listenerFocusNode() {
    if (_focusNode.hasFocus && !_isOnSearch) {
      setState(() => _isOnSearch = true);
      widget.onFocus(_focusNode.hasFocus);
    } else if (!_focusNode.hasFocus && _isOnSearch && _textEditingController.text.isEmpty) {
      setState(() => _isOnSearch = false);
      widget.onFocus(_focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            focusNode: _focusNode,
            controller: _textEditingController,
            onTapOutside: (_) => _focusNode.unfocus(),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              fillColor: AttaColors.white,
              hintText: 'Rechercher',
              isDense: true,
              filled: true,
              hintStyle: AttaTextStyle.label.copyWith(
                height: 0.9,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AttaRadius.full),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: Container(
            width: _isOnSearch ? 40 : 0,
            height: _isOnSearch ? 40 : 0,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: IconButton(
              onPressed: () {
                _textEditingController.clear();
                widget.onFocus(false);
                setState(() => _isOnSearch = false);
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}

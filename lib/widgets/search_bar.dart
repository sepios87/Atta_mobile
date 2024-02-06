import 'package:atta/theme/animation.dart';
import 'package:flutter/material.dart';

class AttaSearchBar extends StatefulWidget {
  const AttaSearchBar({
    required this.onFocus,
    required this.onSearch,
    this.inactiveTrailing,
    super.key,
  });

  final void Function(bool) onFocus;
  final void Function(String) onSearch;
  final Widget? inactiveTrailing;

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
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher',
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: AttaAnimation.fastAnimation,
          reverseDuration: AttaAnimation.mediumAnimation,
          switchInCurve: Curves.easeInOutExpo,
          switchOutCurve: Curves.ease,
          transitionBuilder: (child, animation) {
            if (widget.inactiveTrailing != null) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
              );
            }
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
            );
          },
          child: _isOnSearch
              ? IconButton(
                  onPressed: () {
                    _textEditingController.clear();
                    widget.onFocus(false);
                    setState(() => _isOnSearch = false);
                  },
                  icon: const Icon(Icons.close),
                )
              : SizedBox(
                  key: const ValueKey('inactive'),
                  child: widget.inactiveTrailing,
                ),
        ),
      ],
    );
  }
}

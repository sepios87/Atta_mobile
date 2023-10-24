part of '../home_screen.dart';

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.focusNode,
    required this.textEditingController,
  });

  final FocusNode focusNode;
  final TextEditingController textEditingController;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.textEditingController,
      onTapOutside: (_) => widget.focusNode.unfocus(),
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
          borderRadius: BorderRadius.circular(AttaRadius.radiusFull),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

import 'package:atta/theme/spacing.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.onFavoriteChanged,
    this.borderColor = Colors.white,
    super.key,
  });

  final bool isFavorite;
  final void Function() onFavoriteChanged;
  final Color borderColor;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        setState(() => isFavorite = !isFavorite);
        widget.onFavoriteChanged();
      },
      child: Padding(
        padding: const EdgeInsets.all(AttaSpacing.xxs),
        child: AnimatedCrossFade(
          crossFadeState: isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
          firstChild: const Icon(
            Icons.favorite_rounded,
            color: Colors.red,
            size: 28,
          ),
          secondChild: Icon(
            Icons.favorite_border_rounded,
            color: widget.borderColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}

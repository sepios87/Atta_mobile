import 'package:atta/theme/colors.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.onFavoriteChanged,
    super.key,
  });

  final bool isFavorite;
  final void Function() onFavoriteChanged;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => isFavorite = !isFavorite);
        widget.onFavoriteChanged();
      },
      icon: AnimatedCrossFade(
        crossFadeState: isFavorite ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        firstChild: const Icon(
          Icons.favorite_rounded,
          color: Colors.red,
          size: 30,
        ),
        secondChild: Icon(
          Icons.favorite_border_rounded,
          color: AttaColors.black,
          size: 30,
        ),
      ),
    );
  }
}

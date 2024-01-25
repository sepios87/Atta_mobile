import 'package:atta/widgets/bottom_navigation/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class FavoritePage {
  static const path = '/favorite';
  static const routeName = 'favorite';

  static Widget getScreen() => const _FavoriteScreen();
}

class _FavoriteScreen extends StatelessWidget {
  const _FavoriteScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Placeholder(),
      bottomNavigationBar: AttaBottomNavigationBar(),
    );
  }
}

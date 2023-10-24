import 'package:atta/theme/colors.dart';
import 'package:flutter/material.dart';

class AttaBottomNavigationBar extends StatelessWidget {
  const AttaBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AttaColors.black,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      currentIndex: 1, // TODO: Change this
      selectedItemColor: AttaColors.primaryLight,
      unselectedItemColor: AttaColors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_rounded),
          label: 'Réservations',
        ),
      ],
    );
  }
}

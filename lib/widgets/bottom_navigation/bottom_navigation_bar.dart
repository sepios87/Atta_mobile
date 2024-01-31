import 'package:atta/extensions/context_ext.dart';
import 'package:atta/pages/favorite/favorite_page.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/user_reservations/user_reservations_page.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/widgets/bottom_navigation/cubit/bottom_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum _BottomNavigationItem {
  favorites,
  home,
  reservations;

  factory _BottomNavigationItem.getFromRouteName(String routeName) {
    return _BottomNavigationItem.values.firstWhere(
      (item) => item.routeName == routeName,
      orElse: () => _BottomNavigationItem.home,
    );
  }

  String get label {
    return switch (this) {
      _BottomNavigationItem.favorites => 'Favoris',
      _BottomNavigationItem.home => 'Accueil',
      _BottomNavigationItem.reservations => 'Réservations'
    };
  }

  IconData get icon {
    return switch (this) {
      _BottomNavigationItem.favorites => Icons.favorite_rounded,
      _BottomNavigationItem.home => Icons.home_rounded,
      _BottomNavigationItem.reservations => Icons.shopping_cart_rounded
    };
  }

  String get routeName {
    return switch (this) {
      _BottomNavigationItem.favorites => FavoritePage.routeName,
      _BottomNavigationItem.home => HomePage.routeName,
      _BottomNavigationItem.reservations => UserReservationsPage.routeName,
    };
  }
}

class AttaBottomNavigationBar extends StatelessWidget {
  const AttaBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '';

    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: Theme(
        data: ThemeData(
          splashFactory: InkRipple.splashFactory,
        ),
        child: BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
          builder: (context, state) {
            if (state.user == null) return const SizedBox.shrink();

            return BottomNavigationBar(
              key: const Key('bottom_navigation_bar'),
              currentIndex: _BottomNavigationItem.getFromRouteName(routeName).index,
              onTap: (index) {
                context.adapativeReplacementNamed(_BottomNavigationItem.values[index].routeName);
              },
              backgroundColor: AttaColors.black,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: AttaColors.primaryLight,
              unselectedItemColor: AttaColors.white.withOpacity(0.8),
              items: _BottomNavigationItem.values.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                  tooltip: item.label,
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

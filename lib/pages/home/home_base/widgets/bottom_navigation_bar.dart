part of '../home_base.dart';

enum _BottomNavigationItem {
  favorites,
  home,
  reservations;

  factory _BottomNavigationItem.getFromPath(String? path) {
    return _BottomNavigationItem.values.firstWhere(
      (item) => item.path == path,
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
      _BottomNavigationItem.reservations => Icons.today,
    };
  }

  String get routeName {
    return switch (this) {
      _BottomNavigationItem.favorites => FavoritePage.routeName,
      _BottomNavigationItem.home => HomePage.routeName,
      _BottomNavigationItem.reservations => UserReservationsPage.routeName,
    };
  }

  String get path {
    return switch (this) {
      _BottomNavigationItem.favorites => FavoritePage.path,
      _BottomNavigationItem.home => HomePage.path,
      _BottomNavigationItem.reservations => UserReservationsPage.path,
    };
  }
}

class _AttaBottomNavigationBar extends StatelessWidget {
  const _AttaBottomNavigationBar({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      child: BottomNavigationBar(
        key: const Key('bottom_navigation_bar'),
        currentIndex: _BottomNavigationItem.getFromPath(path).index,
        onTap: (index) {
          context.adapativeReplacementNamed(_BottomNavigationItem.values[index].routeName);
        },
        backgroundColor: AttaColors.black,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: AttaColors.primary,
        unselectedItemColor: AttaColors.white.withOpacity(0.8),
        items: _BottomNavigationItem.values.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }
}

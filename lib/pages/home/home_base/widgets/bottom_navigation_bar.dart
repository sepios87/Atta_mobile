part of '../home_base.dart';

enum _BottomNavigationItem {
  favorites,
  home,
  reservations;

  String get label {
    return switch (this) {
      _BottomNavigationItem.favorites => 'Favoris',
      _BottomNavigationItem.home => 'Resto',
      _BottomNavigationItem.reservations => 'Résa'
    };
  }

  IconData get icon {
    return switch (this) {
      _BottomNavigationItem.favorites => Icons.favorite_outline,
      _BottomNavigationItem.home => Icons.restaurant_rounded,
      _BottomNavigationItem.reservations => Icons.today_outlined,
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
    // Background color is the Scaffold background color
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AttaSpacing.s,
          horizontal: AttaSpacing.m,
        ),
        child: Row(
          children: _BottomNavigationItem.values.map((item) {
            final isSelected = item.path == path;

            return Expanded(
              child: GestureDetector(
                onTap: () => context.adapativeReplacementNamed(item.routeName),
                child: AnimatedContainer(
                  height: 42,
                  duration: AttaAnimation.fastAnimation,
                  curve: Curves.easeIn,
                  padding: EdgeInsets.symmetric(horizontal: isSelected ? 20 : 0),
                  decoration: BoxDecoration(
                    color: isSelected ? AttaColors.primary : AttaColors.black,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: isSelected ? AttaColors.white : AttaColors.white.withOpacity(0.8)),
                      AnimatedSwitcher(
                        duration: AttaAnimation.fastAnimation,
                        reverseDuration: AttaAnimation.mediumAnimation,
                        switchInCurve: Curves.ease,
                        switchOutCurve: Curves.ease,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                              sizeFactor: animation,
                              axis: Axis.horizontal,
                              child: Center(child: child),
                            ),
                          );
                        },
                        child: isSelected
                            ? Text(item.label, style: AttaTextStyle.caption.copyWith(color: AttaColors.white))
                                .withPadding(
                                const EdgeInsets.only(left: AttaSpacing.xs),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

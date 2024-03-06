part of '../main.dart';

String? initialFullPath;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: PreloadPage.path,
  redirect: (context, state) {
    // If not preload data, redirect to preload page
    if (state.fullPath != '/' && !restaurantService.isLoaded) {
      initialFullPath = state.uri.toString();
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: PreloadPage.path,
      builder: (BuildContext context, GoRouterState state) {
        return PreloadPage.getScreen();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, child) {
        return HomeBase(path: state.fullPath, child: child);
      },
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: HomePage.path,
          name: HomePage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return HomePage.getScreen();
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: FavoritePage.path,
          name: FavoritePage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return FavoritePage.getScreen();
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: UserReservationsPage.path,
          name: UserReservationsPage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return UserReservationsPage.getScreen();
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: RestaurantDetailPage.path,
      name: RestaurantDetailPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return RestaurantDetailPage.getScreen(
          RestaurantDetailPageArgument.fromPathParameters(state.pathParameters),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: ReservationPage.path,
      name: ReservationPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return ReservationPage.getScreen(
          ReservationPageArgument.fromPathParameters(state.pathParameters),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: DishDetailPage.path,
      name: DishDetailPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return DishDetailPage.getScreen(
          DishDetailPageArgument.fromPathParameters(state.pathParameters),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: MenuDetailPage.path,
      name: MenuDetailPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return MenuDetailPage.getScreen(
          MenuDetailPageArgument.fromParameters(
            pathParameters: state.pathParameters,
            extra: state.extra,
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AuthPage.path,
      name: AuthPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return AuthPage.getScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: ProfilePage.path,
      name: ProfilePage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return ProfilePage.getScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: CartPage.path,
      name: CartPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return CartPage.getScreen();
      },
    ),
  ],
);

part of '../main.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: PreloadPage.path,
      builder: (BuildContext context, GoRouterState state) {
        return PreloadPage.getScreen();
      },
    ),
    GoRoute(
      path: HomePage.path,
      builder: (BuildContext context, GoRouterState state) {
        return HomePage.getScreen();
      },
    ),
    GoRoute(
      path: RestaurantDetailPage.path,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra! as RestaurantDetailScreenArgument;
        return RestaurantDetailPage.getScreen(args);
      },
    ),
    GoRoute(
      path: LoginPage.path,
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage.getScreen();
      },
    ),
  ],
);

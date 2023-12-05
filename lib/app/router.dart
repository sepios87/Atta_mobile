part of '../main.dart';

String? initialFullPath;

final GoRouter _router = GoRouter(
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
      path: PreloadPage.path,
      builder: (BuildContext context, GoRouterState state) {
        return PreloadPage.getScreen();
      },
    ),
    GoRoute(
      path: HomePage.path,
      name: HomePage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return HomePage.getScreen();
      },
    ),
    GoRoute(
      path: RestaurantDetailPage.path,
      name: RestaurantDetailPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return RestaurantDetailPage.getScreen(
          RestaurantDetailScreenArgument.fromPathParameters(state.pathParameters),
        );
      },
    ),
    GoRoute(
      path: DishDetailPage.path,
      name: DishDetailPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return DishDetailPage.getScreen(
          DishDetailScreenArgument.fromPathParameters(state.pathParameters),
        );
      },
    ),
    GoRoute(
      path: LoginPage.path,
      name: LoginPage.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage.getScreen();
      },
    ),
  ],
);

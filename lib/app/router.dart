part of '../main.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const PreloadScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/restaurant-details',
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra! as RestaurantDetailScreenArgument;
        return RestaurantDetailScreen(
          arguments: args,
        );
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
  ],
);

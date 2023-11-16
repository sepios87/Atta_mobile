import 'package:flutter/material.dart';

class DishDetailScreenArgument {
  const DishDetailScreenArgument({
    required this.restaurantId,
    required this.dishId,
  });

  final String restaurantId;
  final String dishId;
}

class DishDetailPage {
  static const path = '/dish_detail';

  static Widget getScreen() => const _DishDetailScreen();
}

class _DishDetailScreen extends StatelessWidget {
  const _DishDetailScreen();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

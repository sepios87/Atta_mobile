import 'package:flutter/material.dart';

class UserPage {
  static const path = '/user';
  static const routeName = 'user';

  static Widget getScreen() => const _UserScreen();
}

class _UserScreen extends StatelessWidget {
  const _UserScreen();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

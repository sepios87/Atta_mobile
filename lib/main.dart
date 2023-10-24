import 'package:atta/screens/home/home_screen.dart';
import 'package:atta/screens/login_screen.dart';
import 'package:atta/screens/restaurant_detail_screen.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

part 'app/router.dart';
part 'theme/theme.dart';

void main() {
  runApp(const AttaApp());
}

class AttaApp extends StatelessWidget {
  const AttaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AttaColors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AttaColors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp.router(
        theme: _attaThemeData,
        routerConfig: _router,
      ),
    );
  }
}

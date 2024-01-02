import 'dart:ui';

import 'package:atta/screens/dish_detail/dish_detail.dart';
import 'package:atta/screens/home/home_screen.dart';
import 'package:atta/screens/login/login_screen.dart';
import 'package:atta/screens/preload/preload_screen.dart';
import 'package:atta/screens/reservation/reservation_screen.dart';
import 'package:atta/screens/restaurant_detail/restaurant_detail_screen.dart';
import 'package:atta/screens/user/user_screen.dart';
import 'package:atta/services/restaurant_service.dart';
import 'package:atta/services/user_service.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

part 'app/router.dart';
part 'theme/theme.dart';

final userService = UserService();
final restaurantService = RestaurantService();
void main() {
  usePathUrlStrategy();
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
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          },
        ),
        theme: _attaThemeData,
        routerConfig: _router,
        locale: const Locale('fr', 'FR'),
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      ),
    );
  }
}

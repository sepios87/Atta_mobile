import 'dart:ui';

import 'package:atta/pages/auth/auth_page.dart';
import 'package:atta/pages/cart/cart_page.dart';
import 'package:atta/pages/dish_detail/dish_detail_page.dart';
import 'package:atta/pages/favorite/favorite_page.dart';
import 'package:atta/pages/home/home_base/home_base.dart';
import 'package:atta/pages/home/home_page.dart';
import 'package:atta/pages/menu_detail/menu_detail_page.dart';
import 'package:atta/pages/preload/preload_page.dart';
import 'package:atta/pages/profile/profile_page.dart';
import 'package:atta/pages/reservation/reservation_page.dart';
import 'package:atta/pages/restaurant_detail/restaurant_detail_page.dart';
import 'package:atta/pages/user_reservations/user_reservations_page.dart';
import 'package:atta/services/database/db_service.dart';
import 'package:atta/services/location_service.dart';
import 'package:atta/services/reservation_service.dart';
import 'package:atta/services/restaurant_service.dart';
import 'package:atta/services/user_service.dart';
import 'package:atta/theme/colors.dart';
import 'package:atta/theme/radius.dart';
import 'package:atta/theme/spacing.dart';
import 'package:atta/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'app/router.dart';
part 'theme/theme.dart';

final userService = UserService();
final restaurantService = RestaurantService();
final reservationService = ReservationService();
final databaseService = DatabaseService();
final locationService = LocationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).ignore();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_KEY'),
  );

  Intl.systemLocale = await findSystemLocale();

  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'fr'],
  );

  usePathUrlStrategy();

  runApp(LocalizedApp(delegate, const AttaApp()));
}

class AttaApp extends StatelessWidget {
  const AttaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp.router(
        title: 'Atta',
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
        locale: localizationDelegate.currentLocale,
        localizationsDelegates: [
          localizationDelegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales,
      ),
    );
  }
}

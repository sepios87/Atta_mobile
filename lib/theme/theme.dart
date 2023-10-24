part of '../main.dart';

ThemeData get _attaThemeData {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AttaColors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: AttaColors.black,
      foregroundColor: AttaColors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 38),
        backgroundColor: AttaColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AttaRadius.radiusSmall),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      ),
    ),
  );
}

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
        textStyle: AttaTextStyle.button,
        minimumSize: const Size(double.infinity, 38),
        backgroundColor: AttaColors.primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AttaRadius.small),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: AttaSpacing.xxs,
          horizontal: AttaSpacing.xs,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AttaColors.black,
        padding: const EdgeInsets.symmetric(
          vertical: AttaSpacing.xxs,
          horizontal: AttaSpacing.xs,
        ),
        alignment: Alignment.centerLeft,
        textStyle: AttaTextStyle.button,
      ),
    ),
  );
}

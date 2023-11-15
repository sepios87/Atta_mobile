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
    chipTheme: ChipThemeData(
      showCheckmark: false,
      side: const BorderSide(color: Colors.white),
      shape: const StadiumBorder(),
      labelPadding: const EdgeInsets.symmetric(
        horizontal: AttaSpacing.xxs,
      ),
      secondarySelectedColor: AttaColors.white,
      labelStyle: const TextStyle(color: ChipLabelColor()),
      color: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AttaColors.black;
          }
          return AttaColors.white;
        },
      ),
    ),
  );
}

class ChipLabelColor extends Color implements MaterialStateColor {
  const ChipLabelColor() : super(0xFF000000);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white;
    }
    return AttaColors.black;
  }
}

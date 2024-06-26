part of '../main.dart';

ThemeData get _attaThemeData {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AttaColors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: AttaColors.black,
      foregroundColor: AttaColors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AttaColors.white),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AttaColors.black,
      selectionColor: AttaColors.white.withOpacity(0.4),
      selectionHandleColor: AttaColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      labelStyle: AttaTextStyle.label.copyWith(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AttaRadius.full),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AttaSpacing.m,
        vertical: 10,
      ),
      fillColor: AttaColors.white,
      hintStyle: AttaTextStyle.label.copyWith(
        color: Colors.grey,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AttaColors.primary;
          }
          return AttaColors.black;
        },
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: AttaTextStyle.button,
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AttaColors.primary,
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
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AttaColors.black,
        textStyle: AttaTextStyle.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AttaRadius.small),
        ),
        side: BorderSide(color: AttaColors.primary),
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
        alignment: Alignment.center,
        textStyle: AttaTextStyle.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AttaRadius.small),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AttaRadius.medium),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      showCheckmark: false,
      side: const BorderSide(color: Colors.transparent),
      shape: const StadiumBorder(),
      labelPadding: const EdgeInsets.symmetric(horizontal: AttaSpacing.xxs),
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
    dialogTheme: DialogTheme(
      backgroundColor: AttaColors.white,
      surfaceTintColor: AttaColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AttaRadius.medium),
        ),
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

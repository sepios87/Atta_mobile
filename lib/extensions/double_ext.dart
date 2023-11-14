extension DoubleExt on double {
  String get toEuro {
    return '${toStringAsFixed(2)}€';
  }
}

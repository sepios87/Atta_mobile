extension NumExt on num {
  String get toEuro {
    return '${toStringAsFixed(2)}€';
  }
}

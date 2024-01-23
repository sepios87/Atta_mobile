import 'package:flutter/material.dart';

extension MapExt on Map<String, dynamic> {
  T parse<T>(String key, {T? fallback}) {
    try {
      if (!containsKey(key)) throw ArgumentError.value(key, 'key', 'Key not found');
      if (this[key] is! T) throw ArgumentError.value(key, 'key', 'Invalid type for value ${this[key]} - expected $T}');

      return this[key] as T;
    } catch (e) {
      if (fallback == null) rethrow;

      debugPrint('Use fallback: $e');
      return fallback;
    }
  }
}
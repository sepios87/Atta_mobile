import 'package:flutter/material.dart';

extension LocaleExt on Locale {
  String get languageName {
    return switch (languageCode) {
      'en' => 'English',
      'es' => 'Español',
      'pt' => 'Português',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'it' => 'Italiano',
      'nl' => 'Nederlands',
      'pl' => 'Polski',
      'ru' => 'Русский',
      'tr' => 'Türkçe',
      'ja' => '日本語',
      _ => 'Unknown',
    };
  }
}

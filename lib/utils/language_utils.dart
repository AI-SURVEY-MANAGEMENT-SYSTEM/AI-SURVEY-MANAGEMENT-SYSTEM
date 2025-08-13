import 'package:flutter/material.dart';

class LanguageUtils {
  static const List<Locale> supportedLocales = [
    Locale('en', 'IN'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('bn', 'IN'), // Bengali
    Locale('ta', 'IN'), // Tamil
    Locale('te', 'IN'), // Telugu
    Locale('mr', 'IN'), // Marathi
    Locale('kn', 'IN'), // Kannada
    Locale('ml', 'IN'), // Malayalam
    Locale('gu', 'IN'), // Gujarati
    Locale('pa', 'IN'), // Punjabi
    Locale('or', 'IN'), // Odia
    Locale('as', 'IN'), // Assamese
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'bn': 'বাংলা',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'gu': 'ગુજરાતી',
    'pa': 'ਪੰਜਾਬੀ',
    'or': 'ଓଡ଼ିଆ',
    'as': 'অসমীয়া',
  };

  static const Map<String, String> languageNamesEnglish = {
    'en': 'English',
    'hi': 'Hindi',
    'bn': 'Bengali',
    'ta': 'Tamil',
    'te': 'Telugu',
    'mr': 'Marathi',
    'kn': 'Kannada',
    'ml': 'Malayalam',
    'gu': 'Gujarati',
    'pa': 'Punjabi',
    'or': 'Odia',
    'as': 'Assamese',
  };

  static String getLanguageName(String languageCode, {bool inEnglish = false}) {
    if (inEnglish) {
      return languageNamesEnglish[languageCode] ?? languageCode;
    }
    return languageNames[languageCode] ?? languageCode;
  }

  static String getLanguageCode(Locale locale) {
    return locale.languageCode;
  }

  static Locale getLocaleFromCode(String languageCode) {
    return Locale(languageCode, 'IN');
  }

  static bool isSupportedLanguage(String languageCode) {
    return languageNames.containsKey(languageCode);
  }
} 
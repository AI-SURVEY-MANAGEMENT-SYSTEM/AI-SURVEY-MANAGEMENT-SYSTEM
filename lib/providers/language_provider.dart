import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/language_utils.dart';

class LanguageProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  Locale _currentLocale = const Locale('en', 'IN');

  LanguageProvider(this.prefs) {
    _loadSavedLanguage();
  }

  Locale get currentLocale => _currentLocale;

  String get currentLanguageCode => _currentLocale.languageCode;

  void _loadSavedLanguage() {
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null && LanguageUtils.isSupportedLanguage(savedLanguage)) {
      _currentLocale = LanguageUtils.getLocaleFromCode(savedLanguage);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (LanguageUtils.isSupportedLanguage(languageCode)) {
      _currentLocale = LanguageUtils.getLocaleFromCode(languageCode);
      await prefs.setString('selected_language', languageCode);
      notifyListeners();
    }
  }

  String getTranslatedText(String key, {Map<String, String>? args}) {
    // This would typically load from a translation file
    // For now, returning the key as placeholder
    return key;
  }
} 
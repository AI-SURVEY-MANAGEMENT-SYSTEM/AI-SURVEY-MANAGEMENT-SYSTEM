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

  // New: Localized app title
  static String getAppTitle(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'एआई सर्वे सहायक';
      case 'bn':
        return 'এআই সার্ভে সহায়ক';
      case 'ta':
        return 'ஏஐ சர்வே உதவியாளர்';
      case 'te':
        return 'ఏఐ సర్వే సహాయకుడు';
      case 'mr':
        return 'एआय सर्वे सहाय्यक';
      case 'kn':
        return 'ಎಐ ಸಮೀಕ್ಷಾ ಸಹಾಯಕ';
      case 'ml':
        return 'എ.ഐ. സർവേ അസിസ്റ്റന്റ്';
      case 'gu':
        return 'એઆઈ સર્વે સહાયક';
      case 'pa':
        return 'ਏਆਈ ਸਰਵੇ ਸਹਾਇਕ';
      case 'or':
        return 'ଏଆଇ ସର୍ବେ ସହାୟକ';
      case 'as':
        return 'এআই ছৰ্ভে সহায়ক';
      default:
        return 'AI Survey Assistant';
    }
  }

  // New: Localized tagline
  static String getAppTagline(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'सरकारी सर्वे में आपकी बुद्धिमान सहायक';
      case 'bn':
        return 'সরকারি জরিপের জন্য আপনার বুদ্ধিমান সহায়ক';
      case 'ta':
        return 'அரசு கணக்கெடுப்புகளுக்கான உங்கள் புத்திசாலி துணை';
      case 'te':
        return 'ప్రభుత్వ సర్వేల కోసం మీ తెలివైన తోడు';
      case 'mr':
        return 'शासकीय सर्वेसाठी तुमचा बुद्धिमान सहकारी';
      case 'kn':
        return 'ಸರ್ಕಾರಿ ಸಮೀಕ್ಷೆಗಾಗಿ ನಿಮ್ಮ ಬುದ್ಧಿವಂತ ಸಹಾಯಕ';
      case 'ml':
        return 'സർക്കാർ സർവേകൾക്കുള്ള നിങ്ങളുടെ ബുദ്ധിമാനായ കൂട്ടായി';
      case 'gu':
        return 'સરકારી સર્વે માટે તમારો બુદ્ધિશાળી સાથી';
      case 'pa':
        return 'ਸਰਕਾਰੀ ਸਰਵੇਖਣ ਲਈ ਤੁਹਾਡਾ ਸਮਝਦਾਰ ਸਾਥੀ';
      case 'or':
        return 'ସରକାରୀ ସର୍ବେ ପାଇଁ ଆପଣଙ୍କ ଦୃଢ଼ ସହାୟକ';
      case 'as':
        return 'সরকাৰী সমীক্ষাৰ বাবে আপোনাৰ বুদ্ধিমান সংগী';
      default:
        return 'Your intelligent companion for government surveys';
    }
  }
} 
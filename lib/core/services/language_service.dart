import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('de', ''),
  ];

  static Future<Locale> getSavedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_languageKey);
    
    if (languageCode != null) {
      return Locale(languageCode, '');
    }
    
    // Return system locale if supported, otherwise default to English
    final Locale systemLocale = PlatformDispatcher.instance.locale;
    if (supportedLocales.any((locale) => locale.languageCode == systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode, '');
    }
    
    return const Locale('en', '');
  }

  static Future<void> saveLanguage(Locale locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }

  static String getLanguageDisplayName(String languageCode, Locale currentLocale) {
    if (currentLocale.languageCode == 'de') {
      switch (languageCode) {
        case 'en':
          return 'Englisch';
        case 'de':
          return 'Deutsch';
        default:
          return 'Englisch';
      }
    } else {
      switch (languageCode) {
        case 'en':
          return 'English';
        case 'de':
          return 'German';
        default:
          return 'English';
      }
    }
  }
}

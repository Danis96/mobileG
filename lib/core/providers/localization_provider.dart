import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');
  bool _isLoaded = false;

  Locale get currentLocale => _currentLocale;
  bool get isLoaded => _isLoaded;

  LocalizationProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final Locale savedLocale = await LanguageService.getSavedLanguage();
    _currentLocale = savedLocale;
    _isLoaded = true;
    notifyListeners();
    debugPrint('✅ Language loaded: ${savedLocale.languageCode}');
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    await LanguageService.saveLanguage(locale);
    notifyListeners();
    debugPrint('🌍 Language changed to: ${locale.languageCode}');
  }

  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }

  /// Get language flag emoji
  String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      default:
        return '🌍';
    }
  }

  /// Get language name with flag
  String getLanguageDisplayWithFlag(String languageCode) {
    final flag = getLanguageFlag(languageCode);
    final name = LanguageService.getLanguageName(languageCode);
    return '$flag  $name';
  }
}

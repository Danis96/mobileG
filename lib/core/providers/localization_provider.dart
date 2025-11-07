import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', '');

  Locale get currentLocale => _currentLocale;

  LocalizationProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final Locale savedLocale = await LanguageService.getSavedLanguage();
    _currentLocale = savedLocale;
    notifyListeners();
  }

  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;
    
    _currentLocale = locale;
    await LanguageService.saveLanguage(locale);
    notifyListeners();
  }

  bool isCurrentLanguage(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }
}

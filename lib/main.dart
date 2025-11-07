import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:syntax_highlight/syntax_highlight.dart';
import 'core/constants/app_colors.dart';
import 'core/providers/localization_provider.dart';
// import 'core/services/markdown_service.dart';
import 'core/services/markdown_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MarkdownService.initialize();
  runApp(const PresentationGenieApp());
}

class PresentationGenieApp extends StatelessWidget {
  const PresentationGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocalizationProvider(),
      child: Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
          return MaterialApp(
            title: 'PresentationGenie',
            debugShowCheckedModeBanner: false,
            locale: localizationProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('de', '')],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonPrimary, brightness: Brightness.light),
              scaffoldBackgroundColor: AppColors.backgroundWhite,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.backgroundWhite,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColors.inputBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.buttonPrimary, width: 2),
                ),
              ),
              dividerTheme: const DividerThemeData(color: AppColors.borderGray, thickness: 1),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

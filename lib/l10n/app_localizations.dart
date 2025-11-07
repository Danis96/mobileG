import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'PresentationGenie'**
  String get appName;

  /// mihFIBER brand name
  ///
  /// In en, this message translates to:
  /// **'mihFIBER'**
  String get mihFiber;

  /// Fiber optic network technology tagline
  ///
  /// In en, this message translates to:
  /// **'FIBER OPTIC NETWORK TECHNOLOGY'**
  String get fiberOpticNetworkTechnology;

  /// Configure button text
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get configure;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeBack;

  /// Login instruction text
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get logInToYourAccount;

  /// Microsoft login button text
  ///
  /// In en, this message translates to:
  /// **'Continue with Microsoft'**
  String get continueWithMicrosoft;

  /// Last used indicator
  ///
  /// In en, this message translates to:
  /// **'Last used'**
  String get lastUsed;

  /// Or separator text
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// Email address field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Privacy policy agreement text
  ///
  /// In en, this message translates to:
  /// **'By continuing, you acknowledge that you understand and agree to the '**
  String get byContinuingYouAcknowledge;

  /// Privacy policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Configure base URL modal title
  ///
  /// In en, this message translates to:
  /// **'Configure Base URL'**
  String get configureBaseUrl;

  /// Base URL field label
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get baseUrl;

  /// Base URL field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your base URL'**
  String get enterBaseUrl;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Base URL configuration description
  ///
  /// In en, this message translates to:
  /// **'Set the base URL for your AI chatbot API endpoint. This will be used for all API communications.'**
  String get baseUrlDescription;

  /// Chat screen welcome message
  ///
  /// In en, this message translates to:
  /// **'What\'s on the agenda today?'**
  String get whatsOnTheAgendaToday;

  /// Chat input placeholder
  ///
  /// In en, this message translates to:
  /// **'Ask anything'**
  String get askAnything;

  /// ChatGPT reference
  ///
  /// In en, this message translates to:
  /// **'ChatGPT'**
  String get chatGpt;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Account settings section
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Preferences settings section
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// About settings section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// German language option
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// Help and support menu item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Help and support description
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get getHelpAndContactSupport;

  /// Privacy policy description
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readOurPrivacyPolicy;

  /// App version text
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Base URL configuration menu item
  ///
  /// In en, this message translates to:
  /// **'Base URL Configuration'**
  String get baseUrlConfiguration;

  /// Not configured status text
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// Language settings placeholder message
  ///
  /// In en, this message translates to:
  /// **'Language settings coming soon'**
  String get languageSettingsComingSoon;

  /// Help and support placeholder message
  ///
  /// In en, this message translates to:
  /// **'Help & Support coming soon'**
  String get helpAndSupportComingSoon;

  /// Privacy policy placeholder message
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy coming soon'**
  String get privacyPolicyComingSoon;

  /// App version with name
  ///
  /// In en, this message translates to:
  /// **'PresentationGenie v1.0.0'**
  String get presentationGenieVersion;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureYouWantToSignOut;

  /// Base URL update success message
  ///
  /// In en, this message translates to:
  /// **'Base URL updated successfully'**
  String get baseUrlUpdatedSuccessfully;

  /// Base URL configuration success message
  ///
  /// In en, this message translates to:
  /// **'Base URL configured successfully'**
  String get baseUrlConfiguredSuccessfully;

  /// Chat screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with PresentationGenie'**
  String get startAConversationWithPresentationGenie;

  /// Greeting in drawer
  ///
  /// In en, this message translates to:
  /// **'Hi, John Doe'**
  String get hiJohnDoe;

  /// Chat history section title
  ///
  /// In en, this message translates to:
  /// **'Chat History'**
  String get chatHistory;

  /// New chat notification
  ///
  /// In en, this message translates to:
  /// **'New chat started'**
  String get newChatStarted;

  /// Delete chat dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// Delete chat confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String areYouSureYouWantToDeleteChat(String title);

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Chat deletion confirmation
  ///
  /// In en, this message translates to:
  /// **'Chat \"{title}\" deleted'**
  String chatDeleted(String title);

  /// Loading chat message
  ///
  /// In en, this message translates to:
  /// **'Loading chat: {title}'**
  String loadingChat(String title);

  /// Add photos menu option
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// Take photo menu option
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// Add files menu option
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get addFiles;

  /// Add photos selection confirmation
  ///
  /// In en, this message translates to:
  /// **'Add photos selected'**
  String get addPhotosSelected;

  /// Take photo selection confirmation
  ///
  /// In en, this message translates to:
  /// **'Take photo selected'**
  String get takePhotoSelected;

  /// Add files selection confirmation
  ///
  /// In en, this message translates to:
  /// **'Add files selected'**
  String get addFilesSelected;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterAValidEmailAddress;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// Base URL validation error
  ///
  /// In en, this message translates to:
  /// **'Base URL is required'**
  String get baseUrlIsRequired;

  /// URL format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get pleaseEnterAValidUrl;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get informationWeCollect;

  /// Privacy policy information collection content
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This may include your name, email address, and usage data.'**
  String get informationWeCollectContent;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get howWeUseYourInformation;

  /// Privacy policy information usage content
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, and communicate with you about products, services, and promotional offers.'**
  String get howWeUseYourInformationContent;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get informationSharing;

  /// Privacy policy information sharing content
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy. We may share your information with trusted service providers who assist us in operating our services.'**
  String get informationSharingContent;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// Privacy policy data security content
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.'**
  String get dataSecurityContent;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// Privacy policy user rights content
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us. To exercise these rights, please contact us using the information provided below.'**
  String get yourRightsContent;

  /// Privacy policy section title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Privacy policy contact information
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at privacy@mihfiber.com or through our support channels.'**
  String get contactUsContent;

  /// Privacy policy last updated information
  ///
  /// In en, this message translates to:
  /// **'Last updated: November 2024\n\nThis privacy policy is effective as of the date listed above and will remain in effect except with respect to any changes in its provisions in the future.'**
  String get lastUpdated;

  /// Default AI response message
  ///
  /// In en, this message translates to:
  /// **'I understand your request. How can I help you with your presentation today?'**
  String get aiResponseMessage;

  /// Single day ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} day ago'**
  String dayAgo(int count);

  /// Multiple days ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Single hour ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} hour ago'**
  String hourAgo(int count);

  /// Multiple hours ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// Single minute ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} minute ago'**
  String minuteAgo(int count);

  /// Multiple minutes ago timestamp
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// Just now timestamp
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

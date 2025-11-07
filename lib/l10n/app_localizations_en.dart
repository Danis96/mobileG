// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PresentationGenie';

  @override
  String get mihFiber => 'mihFIBER';

  @override
  String get fiberOpticNetworkTechnology => 'FIBER OPTIC NETWORK TECHNOLOGY';

  @override
  String get configure => 'Configure';

  @override
  String get welcomeBack => 'Welcome';

  @override
  String get logInToYourAccount => 'Log in to your account';

  @override
  String get continueWithMicrosoft => 'Continue with Microsoft';

  @override
  String get lastUsed => 'Last used';

  @override
  String get or => 'or';

  @override
  String get emailAddress => 'Email address';

  @override
  String get enterYourEmailAddress => 'Enter your email address';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get byContinuingYouAcknowledge =>
      'By continuing, you acknowledge that you understand and agree to the ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get configureBaseUrl => 'Configure Base URL';

  @override
  String get baseUrl => 'Base URL';

  @override
  String get enterBaseUrl => 'Enter your base URL';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get baseUrlDescription =>
      'Set the base URL for your AI chatbot API endpoint. This will be used for all API communications.';

  @override
  String get whatsOnTheAgendaToday => 'What\'s on the agenda today?';

  @override
  String get askAnything => 'Ask anything';

  @override
  String get chatGpt => 'ChatGPT';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get preferences => 'Preferences';

  @override
  String get about => 'About';

  @override
  String get signOut => 'Sign Out';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get getHelpAndContactSupport => 'Get help and contact support';

  @override
  String get readOurPrivacyPolicy => 'Read our privacy policy';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get baseUrlConfiguration => 'Base URL Configuration';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get languageSettingsComingSoon => 'Language settings coming soon';

  @override
  String get helpAndSupportComingSoon => 'Help & Support coming soon';

  @override
  String get privacyPolicyComingSoon => 'Privacy Policy coming soon';

  @override
  String get presentationGenieVersion => 'PresentationGenie v1.0.0';

  @override
  String get areYouSureYouWantToSignOut => 'Are you sure you want to sign out?';

  @override
  String get baseUrlUpdatedSuccessfully => 'Base URL updated successfully';

  @override
  String get baseUrlConfiguredSuccessfully =>
      'Base URL configured successfully';

  @override
  String get startAConversationWithPresentationGenie =>
      'Start a conversation with PresentationGenie';

  @override
  String get hiJohnDoe => 'Hi, John Doe';

  @override
  String get chatHistory => 'Chat History';

  @override
  String get newChatStarted => 'New chat started';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String areYouSureYouWantToDeleteChat(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String chatDeleted(String title) {
    return 'Chat \"$title\" deleted';
  }

  @override
  String loadingChat(String title) {
    return 'Loading chat: $title';
  }

  @override
  String get addPhotos => 'Add photos';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get addFiles => 'Add files';

  @override
  String get addPhotosSelected => 'Add photos selected';

  @override
  String get takePhotoSelected => 'Take photo selected';

  @override
  String get addFilesSelected => 'Add files selected';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get pleaseEnterAValidEmailAddress =>
      'Please enter a valid email address';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Password must be at least 6 characters';

  @override
  String get baseUrlIsRequired => 'Base URL is required';

  @override
  String get pleaseEnterAValidUrl => 'Please enter a valid URL';

  @override
  String get informationWeCollect => 'Information We Collect';

  @override
  String get informationWeCollectContent =>
      'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support. This may include your name, email address, and usage data.';

  @override
  String get howWeUseYourInformation => 'How We Use Your Information';

  @override
  String get howWeUseYourInformationContent =>
      'We use the information we collect to provide, maintain, and improve our services, process transactions, send you technical notices and support messages, and communicate with you about products, services, and promotional offers.';

  @override
  String get informationSharing => 'Information Sharing';

  @override
  String get informationSharingContent =>
      'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this privacy policy. We may share your information with trusted service providers who assist us in operating our services.';

  @override
  String get dataSecurity => 'Data Security';

  @override
  String get dataSecurityContent =>
      'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.';

  @override
  String get yourRights => 'Your Rights';

  @override
  String get yourRightsContent =>
      'You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us. To exercise these rights, please contact us using the information provided below.';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsContent =>
      'If you have any questions about this Privacy Policy, please contact us at privacy@mihfiber.com or through our support channels.';

  @override
  String get lastUpdated =>
      'Last updated: November 2024\n\nThis privacy policy is effective as of the date listed above and will remain in effect except with respect to any changes in its provisions in the future.';

  @override
  String get aiResponseMessage =>
      'I understand your request. How can I help you with your presentation today?';

  @override
  String dayAgo(int count) {
    return '$count day ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String hourAgo(int count) {
    return '$count hour ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String minuteAgo(int count) {
    return '$count minute ago';
  }

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String get justNow => 'Just now';
}

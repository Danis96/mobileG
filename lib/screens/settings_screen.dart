import 'package:flutter/material.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_assets.dart';
import '../core/providers/localization_provider.dart';
import '../core/services/language_service.dart';
import '../widgets/configure_modal.dart';
import 'login_screen.dart';

class SettingsItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showArrow;

  SettingsItem({required this.title, this.subtitle, required this.icon, this.onTap, this.iconColor, this.showArrow = true});
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  String? _baseUrl;
  bool _isLanguageExpanded = false;
  late AnimationController _languageAnimationController;
  late Animation<double> _languageAnimation;

  @override
  void initState() {
    super.initState();
    _languageAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _languageAnimation = CurvedAnimation(parent: _languageAnimationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _languageAnimationController.dispose();
    super.dispose();
  }

  void _showConfigureModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConfigureModal(
        currentBaseUrl: _baseUrl,
        onSave: (String baseUrl) {
          setState(() {
            _baseUrl = baseUrl;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.baseUrlUpdatedSuccessfully), backgroundColor: AppColors.success));
        },
      ),
    );
  }

  void _toggleLanguageExpansion() {
    setState(() {
      _isLanguageExpanded = !_isLanguageExpanded;
    });

    if (_isLanguageExpanded) {
      _languageAnimationController.forward();
    } else {
      _languageAnimationController.reverse();
    }
  }

  void _changeLanguage(String languageCode) {
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);
    localizationProvider.changeLanguage(Locale(languageCode, ''));

    // Show confirmation
    final languageFlag = localizationProvider.getLanguageFlag(languageCode);
    final languageName = LanguageService.getLanguageName(languageCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$languageFlag Language changed to $languageName'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Close the expansion after selection
    setState(() {
      _isLanguageExpanded = false;
    });
    _languageAnimationController.reverse();
  }

  void _showSignOutDialog() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.signOut,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        content: Text(l10n.areYouSureYouWantToSignOut, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _signOut();
            },
            child: Text(
              l10n.signOut,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  List<SettingsItem> _getSettingsItems() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context);
    final String currentLanguageCode = localizationProvider.currentLocale.languageCode;
    final String currentLanguageFlag = localizationProvider.getLanguageFlag(currentLanguageCode);
    final String currentLanguageName = LanguageService.getLanguageDisplayName(
      currentLanguageCode,
      localizationProvider.currentLocale,
    );

    return [
      // Account Section
      SettingsItem(title: l10n.baseUrlConfiguration, subtitle: _baseUrl ?? l10n.notConfigured, icon: Icons.link, onTap: _showConfigureModal),

      // Preferences Section
      SettingsItem(title: l10n.language, subtitle: '$currentLanguageFlag  $currentLanguageName', icon: Icons.language, onTap: _toggleLanguageExpansion),

      // About Section
      SettingsItem(
        title: l10n.helpAndSupport,
        subtitle: l10n.getHelpAndContactSupport,
        icon: Icons.help_outline,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.helpAndSupportComingSoon)));
        },
      ),
      SettingsItem(
        title: l10n.privacyPolicy,
        subtitle: l10n.readOurPrivacyPolicy,
        icon: Icons.privacy_tip_outlined,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.privacyPolicyComingSoon)));
        },
      ),
      SettingsItem(
        title: l10n.about,
        subtitle: l10n.version,
        icon: Icons.info_outline,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.presentationGenieVersion)));
        },
      ),

      // Sign Out
      SettingsItem(title: l10n.signOut, icon: Icons.logout, iconColor: AppColors.error, onTap: _showSignOutDialog, showArrow: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final settingsItems = _getSettingsItems();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.backgroundGray, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Image.asset(AppAssets.genieIcon, width: 60, height: 60),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4),
                      Text('john.doe@example.com', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Settings Sections
          _buildSection(title: l10n.account, items: settingsItems.sublist(0, 1)),
          const SizedBox(height: 24),

          _buildPreferencesSection(title: l10n.preferences, items: settingsItems.sublist(1, 2)),
          const SizedBox(height: 24),

          _buildSection(title: l10n.about, items: settingsItems.sublist(2, 5)),
          const SizedBox(height: 24),

          // Sign Out
          _buildSettingsItem(settingsItems.last),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<SettingsItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AppColors.backgroundGray, borderRadius: BorderRadius.circular(12)),
          child: Column(children: items.asMap().entries.map((entry) => _buildSettingsItem(entry.value, isLast: entry.key == items.length - 1)).toList()),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection({required String title, required List<SettingsItem> items}) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final LocalizationProvider localizationProvider = Provider.of<LocalizationProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AppColors.backgroundGray, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Language setting item with custom expansion
              _buildLanguageSettingsItem(items.first),

              // Animated expansion for language options
              AnimatedBuilder(
                animation: _languageAnimation,
                builder: (context, child) {
                  return ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _languageAnimation.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: AppColors.borderGray, width: 0.5)),
                        ),
                        child: Column(
                          children: [
                            _buildLanguageOption(
                              languageCode: 'en',
                              languageName: '🇬🇧  ${l10n.english}',
                              description: 'Speech recognition & voice',
                              isSelected: localizationProvider.isCurrentLanguage('en'),
                            ),
                            Container(height: 0.5, color: AppColors.borderGray, margin: const EdgeInsets.symmetric(horizontal: 16)),
                            _buildLanguageOption(
                              languageCode: 'de',
                              languageName: '🇩🇪  ${l10n.german}',
                              description: 'Spracherkennung & Stimme',
                              isSelected: localizationProvider.isCurrentLanguage('de'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSettingsItem(SettingsItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.mihFiberGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(item.icon, size: 20, color: AppColors.mihFiberGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(item.subtitle!, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
              AnimatedRotation(
                turns: _isLanguageExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.expand_more, color: AppColors.textTertiary, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    String? description,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _changeLanguage(languageCode),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const SizedBox(width: 56), // Align with the main item content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.mihFiberGreen : AppColors.textPrimary,
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.mihFiberGreen.withOpacity(0.7) : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(color: AppColors.mihFiberGreen, borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              if (!isSelected)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGray, width: 2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(SettingsItem item, {bool isLast = true}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: !isLast ? const Border(bottom: BorderSide(color: AppColors.borderGray, width: 0.5)) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.iconColor?.withValues(alpha: 0.1) ?? AppColors.mihFiberGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 20, color: item.iconColor ?? AppColors.mihFiberGreen),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: item.iconColor ?? AppColors.textPrimary),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(item.subtitle!, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
              if (item.showArrow) Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_assets.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/configure_modal.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _baseUrl;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.baseUrlConfiguredSuccessfully), backgroundColor: AppColors.success));
        },
      ),
    );
  }

  void _handleMicrosoftLogin() {
    // Simulate Microsoft login
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _navigateToChat();
      }
    });
  }

  void _handleEmailLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _navigateToChat();
        }
      });
    }
  }

  void _navigateToChat() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ChatScreen()));
  }

  void _showPrivacyPolicyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderGray, borderRadius: BorderRadius.circular(2)),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.privacyPolicy,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.mihFiberGreenDark),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.mihFiberGreen),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPrivacySection(AppLocalizations.of(context)!.informationWeCollect, AppLocalizations.of(context)!.informationWeCollectContent),
                    const SizedBox(height: 24),
                    _buildPrivacySection(AppLocalizations.of(context)!.howWeUseYourInformation, AppLocalizations.of(context)!.howWeUseYourInformationContent),
                    const SizedBox(height: 24),
                    _buildPrivacySection(AppLocalizations.of(context)!.informationSharing, AppLocalizations.of(context)!.informationSharingContent),
                    const SizedBox(height: 24),
                    _buildPrivacySection(AppLocalizations.of(context)!.dataSecurity, AppLocalizations.of(context)!.dataSecurityContent),
                    const SizedBox(height: 24),
                    _buildPrivacySection(AppLocalizations.of(context)!.yourRights, AppLocalizations.of(context)!.yourRightsContent),
                    const SizedBox(height: 24),
                    _buildPrivacySection(AppLocalizations.of(context)!.contactUs, AppLocalizations.of(context)!.contactUsContent),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mihFiberAccent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.mihFiberGreen.withOpacity(0.3)),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.lastUpdated,
                        style: const TextStyle(fontSize: 14, color: AppColors.mihFiberGreenDark, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(color: AppColors.mihFiberGreen, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(content, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5)),
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailIsRequired;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.pleaseEnterAValidEmailAddress;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.passwordIsRequired;
    }

    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMustBeAtLeast6Characters;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: TextButton(
          onPressed: _showConfigureModal,
          child: Text(AppLocalizations.of(context)!.configure, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        leadingWidth: 130,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Genie logo
                      Image.asset(AppAssets.genieIcon, width: 60, height: 60),

                      // mihFIBER text logo
                      Image.asset(AppAssets.fiberIcon, width: 200, height: 60),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Welcome text
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(AppLocalizations.of(context)!.logInToYourAccount, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                const SizedBox(height: 32),

                // Microsoft login button
                CustomButton(
                  text: AppLocalizations.of(context)!.continueWithMicrosoft,
                  type: ButtonType.outline,
                  width: double.infinity,
                  isLoading: _isLoading,
                  onPressed: _handleMicrosoftLogin,
                  icon: Image.asset(AppAssets.microsoftIcon, width: 20, height: 20),
                ),

                const SizedBox(height: 32),

                // Or divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.borderGray)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(AppLocalizations.of(context)!.or, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    ),
                    const Expanded(child: Divider(color: AppColors.borderGray)),
                  ],
                ),
                const SizedBox(height: 32),

                // Email field
                CustomTextField(
                  label: AppLocalizations.of(context)!.emailAddress,
                  hintText: AppLocalizations.of(context)!.enterYourEmailAddress,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 20),

                // Password field
                CustomTextField(
                  label: AppLocalizations.of(context)!.password,
                  hintText: AppLocalizations.of(context)!.enterYourPassword,
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 32),

                // Sign in button
                CustomButton(
                  text: AppLocalizations.of(context)!.signIn,
                  type: ButtonType.primary,
                  width: double.infinity,
                  isLoading: _isLoading,
                  onPressed: _handleEmailLogin,
                ),
                const SizedBox(height: 24),

                // Privacy policy
                Center(
                  child: GestureDetector(
                    onTap: _showPrivacyPolicyModal,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.byContinuingYouAcknowledge),
                          TextSpan(
                            text: AppLocalizations.of(context)!.privacyPolicy,
                            style: const TextStyle(color: AppColors.mihFiberGreen, decoration: TextDecoration.underline, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

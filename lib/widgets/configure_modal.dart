import 'package:flutter/material.dart';
import 'package:presentationgenie/l10n/app_localizations.dart';
import '../core/constants/app_colors.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class ConfigureModal extends StatefulWidget {
  final String? currentBaseUrl;
  final Function(String) onSave;

  const ConfigureModal({super.key, this.currentBaseUrl, required this.onSave});

  @override
  State<ConfigureModal> createState() => _ConfigureModalState();
}

class _ConfigureModalState extends State<ConfigureModal> {
  late final TextEditingController _baseUrlController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(text: widget.currentBaseUrl ?? '');
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_baseUrlController.text.trim());
      Navigator.of(context).pop();
    }
  }

  String? _validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.baseUrlIsRequired;
    }

    final trimmedValue = value.trim();
    final uri = Uri.tryParse(trimmedValue);
    if (uri == null || !uri.hasAbsolutePath) {
      return AppLocalizations.of(context)!.pleaseEnterAValidUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderGray, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                const Icon(Icons.settings, color: AppColors.mihFiberGreen, size: 24),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.configureBaseUrl,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(AppLocalizations.of(context)!.baseUrlDescription, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 24),

            // Base URL Input
            CustomTextField(
              label: AppLocalizations.of(context)!.baseUrl,
              hintText: AppLocalizations.of(context)!.enterBaseUrl,
              controller: _baseUrlController,
              keyboardType: TextInputType.url,
              validator: _validateUrl,
              prefixIcon: const Icon(Icons.link, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(text: AppLocalizations.of(context)!.cancel, type: ButtonType.secondary, onPressed: () => Navigator.of(context).pop()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(text: AppLocalizations.of(context)!.save, type: ButtonType.primary, onPressed: _handleSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

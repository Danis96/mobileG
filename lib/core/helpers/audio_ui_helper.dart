import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../services/audio_service.dart';
import '../services/language_service.dart';
import '../providers/localization_provider.dart';
import '../../screens/settings_screen.dart';

/// Helper class for audio-related UI operations (permissions, dialogs, etc.)
class AudioUIHelper {
  /// Check and request microphone permission with user-friendly dialogs
  static Future<bool> checkAndRequestMicrophonePermission(
    BuildContext context,
    AudioService audioService,
  ) async {
    final permissionStatus = await audioService.checkMicrophonePermission();

    // Permission already granted
    if (permissionStatus.isGranted) {
      return true;
    }

    // Permission permanently denied - show dialog to go to settings
    if (permissionStatus.isPermanentlyDenied) {
      if (context.mounted) {
        _showPermissionDeniedDialog(context);
      }
      return false;
    }

    // Permission not granted - try to request it
    final granted = await audioService.requestMicrophonePermission();

    if (!granted && context.mounted) {
      // Check if it became permanently denied after request
      final newStatus = await audioService.checkMicrophonePermission();
      if (newStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog(context);
      } else {
        _showPermissionDialog(context);
      }
      return false;
    }

    return granted;
  }

  /// Show microphone permission required dialog (first time denial)
  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mic_off, color: AppColors.error),
            const SizedBox(width: 12),
            Text(
              'Microphone Permission Required',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: const Text(
          'This app needs microphone access to record voice messages. Please grant permission in your device settings.',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: const TextStyle(
                color: AppColors.mihFiberGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when permission is permanently denied
  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must take action
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.block, color: AppColors.primaryOrange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Microphone Permission Denied',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Microphone access has been denied. To use voice messages, you need to enable microphone permission in your device settings.',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mihFiberAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.mihFiberGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.mihFiberGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Go to Settings → Permissions → Microphone → Enable',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.mihFiberGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mihFiberGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings, size: 18),
                SizedBox(width: 8),
                Text(
                  'Open Settings',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when no speech is detected
  static void showNoSpeechDetectedDialog(
    BuildContext context,
    VoidCallback onTryAgain,
  ) {
    final localizationProvider = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );
    final currentLanguageCode = localizationProvider.currentLocale.languageCode;
    final languageFlag = localizationProvider.getLanguageFlag(currentLanguageCode);
    final languageName = LanguageService.getLanguageName(currentLanguageCode);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mic_none, color: AppColors.primaryOrange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No Speech Detected',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'I couldn\'t hear any speech. Please make sure:',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _buildCheckItem('🎤 Your microphone is working'),
            const SizedBox(height: 8),
            _buildCheckItem('🔊 You\'re speaking clearly'),
            const SizedBox(height: 8),
            _buildCheckItem('$languageFlag You\'re speaking in $languageName'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mihFiberAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.mihFiberGreen.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.language, color: AppColors.mihFiberGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Currently listening for: $languageFlag $languageName',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mihFiberGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to settings to change language
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Text(
              'Change Language',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Try again callback
              onTryAgain();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mihFiberGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build check list items
  static Widget _buildCheckItem(String text) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  /// Start listening for speech with all error handling
  static Future<void> startListeningWithErrorHandling({
    required BuildContext context,
    required AudioService audioService,
    required Function(String) onResult,
    required VoidCallback onTryAgain,
  }) async {
    // Check and request permission first
    final hasPermission = await checkAndRequestMicrophonePermission(
      context,
      audioService,
    );

    if (!hasPermission) return;

    // Get current language
    final localizationProvider = Provider.of<LocalizationProvider>(
      context,
      listen: false,
    );
    final currentLanguageCode = localizationProvider.currentLocale.languageCode;

    // Start listening
    await audioService.startListening(
      onResult: onResult,
      locale: audioService.getSttLocale(currentLanguageCode),
      onNoSpeechDetected: () {
        if (context.mounted) {
          showNoSpeechDetectedDialog(context, onTryAgain);
        }
      },
    );

    // Show initial feedback
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎤 Start speaking now...'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}


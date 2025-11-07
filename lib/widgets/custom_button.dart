import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? icon;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
    this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = enabled ? AppColors.buttonPrimary : AppColors.textTertiary;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.buttonSecondary;
        textColor = AppColors.textPrimary;
        borderColor = Colors.transparent;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = AppColors.buttonPrimary;
        borderColor = AppColors.borderGray;
        break;
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: type == ButtonType.primary ? 2 : 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

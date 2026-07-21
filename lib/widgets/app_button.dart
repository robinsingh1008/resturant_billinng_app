// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
// import 'package:ticket_clippers/ticket_clippers.dart';

class AppButton extends StatelessWidget {
  final String? buttonText;
  final String? iconText;
  final Widget? child;
  final VoidCallback? onPressed;

  // Optional custom colors
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Gradient? buttonGradient;
  final Color? disabledColor;

  // Dimensions
  final double? width;
  final double? height;
  final double borderRadius;
  final double elevation;

  // Typography
  final double fontSize;
  final FontWeight fontWeight;

  // Interaction
  final bool hasSound;
  final bool hasVibration;
  final bool isDisabled;
  final bool isLoading;
  final ImageProvider? image;
  final double imageSize;

  const AppButton({
    required super.key,
    this.buttonText,
    this.iconText,
    this.child,
    this.onPressed,
    this.buttonColor,
    this.buttonTextColor,
    this.buttonGradient,
    this.disabledColor,
    this.width,
    this.height,
    this.borderRadius = 11,
    this.elevation = 1,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.hasSound = false,
    this.hasVibration = false,
    this.isDisabled = false,
    this.isLoading = false,
    this.image,
    this.imageSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius == 11 ? 14.0 : borderRadius;
    final effectiveHeight = height ?? 50;
    final isInactive = isDisabled || isLoading;
    final defaultGradient = isInactive ? null : AppColors.primaryGradient;
    final effectiveGradient =
        buttonGradient ?? (buttonColor == null ? defaultGradient : null);
    final effectiveColor = isInactive
        ? (disabledColor ?? const Color(0xFFB6C0CE))
        : buttonColor;

    return Container(
      height: effectiveHeight,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: effectiveGradient == null ? effectiveColor : null,
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(effectiveRadius),
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: (buttonColor ?? AppColors.primaryDark).withValues(
                alpha: isInactive ? 0.12 : 0.28,
              ),
              blurRadius: elevation == 1 ? 14 : elevation,
              offset: const Offset(0, 7),
            ),
        ],
      ),
      child: ElevatedButton(
        key: key,
        onPressed: isInactive
            ? null
            : () {
                onPressed?.call();
              },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Center(
                child:
                    child ??
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (iconText != null)
                          Text(
                            iconText!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: fontSize,
                              color: buttonTextColor ?? Colors.white,
                              fontWeight: fontWeight,
                              height: 1,
                            ),
                          ),
                        if (iconText != null && image != null)
                          const SizedBox(width: 8),
                        if (image != null)
                          Image(
                            image: image!,
                            width: imageSize,
                            height: imageSize,
                          ),
                        if ((iconText != null || image != null) &&
                            buttonText != null)
                          const SizedBox(width: 8),
                        if (buttonText != null)
                          Text(
                            buttonText!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: fontSize,
                              color: buttonTextColor ?? Colors.white,
                              fontWeight: fontWeight,
                              height: 1,
                            ),
                          ),
                      ],
                    ),
              ),
      ),
    );
  }
}

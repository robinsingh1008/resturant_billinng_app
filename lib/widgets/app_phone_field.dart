import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String initialCountryCode;
  final Function(String)? onChanged;
  final Function(dynamic)? onCountryChanged;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? labelColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? focusedBorderWidth;
  final Color? dropdownIconColor;
  final Color? fillColor;
  final double borderRadius;
  final double? minHeight;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(PhoneNumber?)? validator;
  final AutovalidateMode autovalidateMode;
  final bool readOnly;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.labelText,
    this.initialCountryCode = 'IN',
    this.onChanged,
    this.onCountryChanged,
    this.onTap,
    this.textColor,
    this.labelColor,
    this.hintText,
    this.borderColor,
    this.focusedBorderColor,
    this.focusedBorderWidth,
    this.dropdownIconColor,
    this.fillColor,
    this.borderRadius = 12,
    this.minHeight = 58,
    this.contentPadding,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final radius = BorderRadius.circular(borderRadius);

    OutlineInputBorder borderFromTheme(
      InputBorder? themeBorder, {
      Color? color,
      double? width,
    }) {
      final border = themeBorder is OutlineInputBorder ? themeBorder : null;
      final borderSide = border?.borderSide ?? BorderSide.none;
      final sideColor = color ?? borderColor;

      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: sideColor == null
            ? borderSide
            : borderSide.copyWith(color: sideColor, width: width),
      );
    }

    final field = IntlPhoneField(
      readOnly: readOnly,
      controller: controller,
      initialCountryCode: initialCountryCode,
      keyboardType: TextInputType.phone,
      onTap: readOnly ? null : onTap,
      validator: validator,
      cursorColor: textColor ?? theme.textTheme.bodyLarge?.color,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      showDropdownIcon: !readOnly,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: readOnly
            ? Colors.grey.shade400
            : (dropdownIconColor ?? theme.iconTheme.color),
      ),
      dropdownTextStyle: TextStyle(
        color: readOnly
            ? Colors.grey.shade400
            : (labelColor ?? theme.textTheme.bodyMedium?.color),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor ?? theme.textTheme.bodyLarge?.color,
      ),
      onCountryChanged: readOnly ? null : onCountryChanged,
      onChanged: (value) {
        if (!readOnly) onChanged?.call(value.completeNumber);
      },
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: null,
        counterText: '',
        hintText: hintText,
        errorStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),

        filled: true,
        fillColor: fillColor ?? inputTheme.fillColor,
        constraints: minHeight == null
            ? inputTheme.constraints
            : (inputTheme.constraints ?? const BoxConstraints()).copyWith(
                minHeight: minHeight,
              ),
        hintStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.textTheme.bodyMedium?.color,
        ),
        border: borderFromTheme(inputTheme.border),
        focusedBorder: borderFromTheme(
          inputTheme.focusedBorder,
          color: focusedBorderColor,
          width: focusedBorderWidth,
        ),
        enabledBorder: borderFromTheme(inputTheme.enabledBorder),
        errorBorder: borderFromTheme(inputTheme.errorBorder),
        disabledBorder: borderFromTheme(inputTheme.disabledBorder),
        contentPadding:
            contentPadding ??
            inputTheme.contentPadding ??
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: labelColor ?? theme.textTheme.bodyMedium?.color,
        ),
      ),
      invalidNumberMessage: "Please enter your mobile number",
    );

    if (!readOnly) return field;

    final absorbedField = AbsorbPointer(absorbing: true, child: field);
    if (onTap == null) return absorbedField;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: absorbedField,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final String? prefixText;
  final String? suffixText;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final Color? labelColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final Color? fillColor;
  final double borderRadius;
  final double? maxsize;
  final bool hasBorder;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.name,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.prefixText,
    this.suffixText,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.labelColor,
    this.textColor,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.fillColor,
    this.borderRadius = 30,
    this.hasBorder = false,
    this.isDense = false,
    this.contentPadding,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxsize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final border = _inputBorder(inputTheme.border, theme);
    final enabledBorder = _inputBorder(inputTheme.enabledBorder, theme);
    final focusedBorder = _inputBorder(inputTheme.focusedBorder, theme);
    final errorBorder = _inputBorder(inputTheme.errorBorder, theme);
    final disabledBorder = _inputBorder(inputTheme.disabledBorder, theme);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      maxLines: maxsize != null ? null : 1,
      inputFormatters: inputFormatters,
      cursorColor: textColor ?? theme.textTheme.bodyLarge?.color,
      style:
          textStyle ??
          theme.textTheme.bodyMedium?.copyWith(
            color: textColor ?? theme.textTheme.bodyLarge?.color,
          ),
      onTap: onTap,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconConstraints: prefixIconConstraints,
        prefixText: prefixText,
        suffixText: suffixText,
        filled: true,
        // filled: inputTheme.filled,
        fillColor: fillColor ?? inputTheme.fillColor,
        border: border,
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        disabledBorder: disabledBorder,
        isDense: isDense,
        contentPadding:
            contentPadding ??
            inputTheme.contentPadding ??
            const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: labelColor ?? theme.textTheme.bodyMedium?.color,
        ),
        hintStyle:
            hintStyle ??
            theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
      ),
    );
  }

  InputBorder _inputBorder(InputBorder? source, ThemeData theme) {
    if (!hasBorder) return InputBorder.none;

    final defaultSide = BorderSide(color: theme.dividerColor);
    final side = source is OutlineInputBorder ? source.borderSide : defaultSide;

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: side,
    );
  }
}
